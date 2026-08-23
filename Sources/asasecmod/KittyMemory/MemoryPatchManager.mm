#import "MemoryPatchManager.h"
#include "MemoryModifier.hpp"
#include <vector>

@implementation MemoryPatchManager
+ (BOOL)writeMemoryAtOffset:(uint64_t)offset withBytes:(NSArray<NSNumber *> *)bytes forLibrary:(NSString *)libraryName {
    Mach_Info info = MemKitty::getMemoryMachInfo([libraryName UTF8String]);
    if (!info.header) return NO;

    uintptr_t targetAddress = info.slide + offset;

    std::vector<uint8_t> patchBytes;
    for (NSNumber *num in bytes) {
        patchBytes.push_back([num unsignedCharValue]);
    }

    MemoryModifier modifier((void *)targetAddress, patchBytes.data(), patchBytes.size());
    return modifier.Modify();
}
@end
