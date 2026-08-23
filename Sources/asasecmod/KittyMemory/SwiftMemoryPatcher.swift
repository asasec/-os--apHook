import Foundation
import MachO
import Darwin

public class SwiftMemoryPatcher {
    
    private struct PatchRecord {
        let address: UInt
        let originalBytes: [UInt8]
    }
    
    private static var activePatches: [UInt64: PatchRecord] = [:]
    
    public static func getModuleSlide(named moduleName: String) -> UInt {
        let imageCount = _dyld_image_count()
        for i in 0..<imageCount {
            if let namePtr = _dyld_get_image_name(i),
               let name = String(validatingUTF8: namePtr),
               name.contains(moduleName) {
                if let _ = _dyld_get_image_header(i) {
                    return UInt(_dyld_get_image_vmaddr_slide(i))
                }
            }
        }
        return 0
    }
    
    @discardableResult
    public static func patchMemory(offset: UInt64, bytes: [UInt8], forLibrary libraryName: String) -> Bool {
        let slide = getModuleSlide(named: libraryName)
        guard slide != 0 else { return false }
        
        let targetAddress = slide + UInt(offset)
        let size = bytes.count
        
        let pointer = UnsafeMutableRawPointer(bitPattern: targetAddress)
        guard let ptr = pointer else { return false }
        
        if activePatches[offset] == nil {
            var originalBytes = Array(repeating: UInt8(0), count: size)
            _ = originalBytes.withUnsafeMutableBufferPointer { originalBuffer in
                memcpy(originalBuffer.baseAddress, ptr, size)
            }
            activePatches[offset] = PatchRecord(address: targetAddress, originalBytes: originalBytes)
        }
        
        let pageSize = UInt(vm_page_size)
        let pageStart = targetAddress & ~(pageSize - 1)
        
        let kr = mprotect(UnsafeMutableRawPointer(bitPattern: pageStart), Int(pageSize), PROT_READ | PROT_WRITE | PROT_EXEC)
        guard kr == 0 else { return false }
        
        bytes.withUnsafeBufferPointer { buffer in
            ptr.copyMemory(from: buffer.baseAddress!, byteCount: size)
        }
        
        return true
    }
    
    @discardableResult
    public static func restoreMemory(offset: UInt64) -> Bool {
        guard let record = activePatches[offset] else { return false }
        
        let targetAddress = record.address
        let size = record.originalBytes.count
        
        let pointer = UnsafeMutableRawPointer(bitPattern: targetAddress)
        guard let ptr = pointer else { return false }
        
        let pageSize = UInt(vm_page_size)
        let pageStart = targetAddress & ~(pageSize - 1)
        
        let kr = mprotect(UnsafeMutableRawPointer(bitPattern: pageStart), Int(pageSize), PROT_READ | PROT_WRITE | PROT_EXEC)
        guard kr == 0 else { return false }
        
        record.originalBytes.withUnsafeBufferPointer { buffer in
            ptr.copyMemory(from: buffer.baseAddress!, byteCount: size)
        }
        
        activePatches.removeValue(forKey: offset)
        return true
    }
}
