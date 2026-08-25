import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject?, Bool) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("payForProduct:askToBuy:")
    
    let replace: T = { selfObj, sel, product, askToBuy in
        autoreleasepool {
            // selfObj ve product nesnelerinin bellekte güvenli olduğundan emin oluyoruz
            guard let selfInstance = Optional(selfObj), let validProduct = product else {
                return
            }
            
            // Gelen nesnenin sınıfını (Objective-C class adını) güvenli bir şekilde öğreniyoruz
            let productClass = object_getClass(validProduct)
            let className = productClass.map { String(describing: $0) } ? "Bilinmeyen Sınıf"
            
            // Ürün ID'sini ve sınıf adını ekranda aynı anda gösterelim
            let productID = "\(validProduct)"
            
            DispatchQueue.main.async {
                AlertHelper.show(
                    title: "WscIapHook Başarılı!",
                    message: "Ürün ID: \(productID)\nSınıfı: \(className)"
                )
            }
            
            // İşlemi doğrudan tamamlandı olarak işaretleyip oyuna veriyoruz
            let completeSelector = NSSelectorFromString("completeTransaction:")
            
            // Opsiyonel olan AnyClass? değerini güvenli bir şekilde açıyoruz (Unwrap)
            guard let targetClass = object_getClass(selfInstance) else {
                return
            }
            
            if class_respondsToSelector(targetClass, completeSelector),
               let completeIMP = class_getMethodImplementation(targetClass, completeSelector) {
                
                typealias CompleteFunc = @convention(c) (AnyObject, Selector, AnyObject) -> Void
                let complete = unsafeBitCast(completeIMP, to: CompleteFunc.self)
                complete(selfInstance, completeSelector, validProduct)
            }
        }
    }
}
