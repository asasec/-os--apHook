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
            
            // Arayüze satın almanın başarılı olduğuna dair bilgi veriyoruz
            DispatchQueue.main.async {
                AlertHelper.show(
                    title: "Başarılı Satın Alım!",
                    message: "Ürün ücretsiz olarak simüle edildi."
                )
            }
            
            // İşlemi doğrudan tamamlandı olarak işaretleyip oyuna veriyoruz
            let completeSelector = NSSelectorFromString("completeTransaction:")
            let targetClass: AnyClass = object_getClass(selfInstance)
            
            if class_respondsToSelector(targetClass, completeSelector),
               let completeIMP = class_getMethodImplementation(targetClass, completeSelector) {
                
                typealias CompleteFunc = @convention(c) (AnyObject, Selector, AnyObject) -> Void
                let complete = unsafeBitCast(completeIMP, to: CompleteFunc.self)
                complete(selfInstance, completeSelector, validProduct)
            }
        }
    }
}
