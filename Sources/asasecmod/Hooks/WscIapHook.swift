import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject?, Bool) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("payForProduct:askToBuy:")
    
    let replace: T = { selfObj, sel, product, askToBuy in
        autoreleasepool {
            // 1. selfObj ve product nesnelerinin geçerliliğini kontrol et
            guard let selfInstance = Optional(selfObj), let validProduct = product else {
                DispatchQueue.main.async {
                    AlertHelper.show(
                        title: "Hata!",
                        message: "Satın alma başarısız: Geçersiz nesne veya nil referans."
                    )
                }
                return
            }
            
            // 2. Güvenli string dönüşümü (Memory leak veya bad access riskine karşı)
            let productName = unsafeBitCast(validProduct, to: AnyObject.self) !== nil 
                ? String(describing: validProduct) 
                : "Bilinmeyen Ürün"
            
            DispatchQueue.main.async {
                AlertHelper.show(
                    title: "Gelişmiş Hile Aktif!",
                    message: "Ürün simüle ediliyor:\n\(productName)"
                )
            }
            
            // 3. Güvenli Selector ve IMP Çağrıları
            let targetClass: AnyClass = object_getClass(selfInstance)
            
            // sendResult kontrolü
            let sendResultSelector = NSSelectorFromString("sendResult:forProduct:andPayload:")
            if class_respondsToSelector(targetClass, sendResultSelector),
               let sendResultIMP = class_getMethodImplementation(targetClass, sendResultSelector) {
                
                typealias SendResultFunc = @convention(c) (AnyObject, Selector, Int32, AnyObject, AnyObject?) -> Void
                let sendResult = unsafeBitCast(sendResultIMP, to: SendResultFunc.self)
                sendResult(selfInstance, sendResultSelector, 0, validProduct, nil)
            }
            
            // completeTransaction kontrolü
            let completeSelector = NSSelectorFromString("completeTransaction:")
            if class_respondsToSelector(targetClass, completeSelector),
               let completeIMP = class_getMethodImplementation(targetClass, completeSelector) {
                
                typealias CompleteFunc = @convention(c) (AnyObject, Selector, AnyObject) -> Void
                let complete = unsafeBitCast(completeIMP, to: CompleteFunc.self)
                complete(selfInstance, completeSelector, validProduct)
            }
        }
    }
}
