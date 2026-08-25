import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    // Objective-C ve Swift arasındaki olası imza uyuşmazlıklarını önleyen esnek tip tanımı
    typealias T = @convention(c) (AnyObject, Selector, AnyObject?, Bool) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("payForProduct:askToBuy:")
    
    let replace: T = { selfObj, sel, product, askToBuy in
        // Çökme (Crash) riskini sıfıra indirmek için her şeyi havuz ve güvenli blok içine alıyoruz
        autoreleasepool {
            guard let validProduct = product else {
                DispatchQueue.main.async {
                    AlertHelper.show(
                        title: "Hata!", 
                        message: "Satın alma başarısız: Ürün nesnesi nil geldi."
                    )
                }
                return
            }
            
            let productName = String(describing: validProduct)
            
            // Arayüz bildirimini güvenli bir şekilde ana thread'e iletiyoruz
            DispatchQueue.main.async {
                AlertHelper.show(
                    title: "Gelişmiş Hile Aktif!", 
                    message: "Ürün simüle ediliyor:\n\(productName)"
                )
            }
            
            // 1. IOSIAP sınıfının sonuç metodunu güvenli tetikleme
            let sendResultSelector = NSSelectorFromString("sendResult:forProduct:andPayload:")
            if let targetClass = object_getClass(selfObj),
               class_respondsToSelector(targetClass, sendResultSelector) {
                
                typealias SendResultFunc = @convention(c) (AnyObject, Selector, Int32, AnyObject, AnyObject?) -> Void
                if let sendResultIMP = class_getMethodImplementation(targetClass, sendResultSelector) {
                    let sendResult = unsafeBitCast(sendResultIMP, to: SendResultFunc.self)
                    sendResult(selfObj, sendResultSelector, 0, validProduct, nil)
                }
            }
            
            // 2. completeTransaction metodunu güvenli tetikleme
            let completeSelector = NSSelectorFromString("completeTransaction:")
            if let targetClass = object_getClass(selfObj),
               class_respondsToSelector(targetClass, completeSelector) {
                
                typealias CompleteFunc = @convention(c) (AnyObject, Selector, AnyObject) -> Void
                if let completeIMP = class_getMethodImplementation(targetClass, completeSelector) {
                    let complete = unsafeBitCast(completeIMP, to: CompleteFunc.self)
                    complete(selfObj, completeSelector, validProduct)
                }
            }
        }
    }
}
