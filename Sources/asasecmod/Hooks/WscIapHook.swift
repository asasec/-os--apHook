import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject, Bool) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("payForProduct:askToBuy:")
    
    let replace: T = { selfObj, sel, product, askToBuy in
        let productName = String(describing: product)
        print("[WscIapHook] Satın alma yakalandı, ürün: \(productName)")
        
        // 1. İstersen bildirim amaçlı küçük bir alert bırakabilirsin veya tamamen kaldırabilirsin
        AlertHelper.show(
            title: "Hile Aktif!", 
            message: "Ürün başarıyla satın alındı simüle ediliyor:\n\(productName)"
        )
        
        // 2. IOSIAP sınıfının kendi içindeki başarılı sonuç fonksiyonunu tetikleyelim
        // sendResult:forProduct:andPayload: metodunu çağırıyoruz (result = 0 -> Başarılı)
        let sendResultSelector = NSSelectorFromString("sendResult:forProduct:andPayload:")
        if class_respondsToSelector(object_getClass(selfObj), sendResultSelector) {
            typealias SendResultFunc = @convention(c) (AnyObject, Selector, Int32, AnyObject, AnyObject?) -> Void
            let sendResultIMP = class_getMethodImplementation(object_getClass(selfObj), sendResultSelector)
            let sendResult = unsafeBitCast(sendResultIMP, to: SendResultFunc.self)
            
            // 0 -> Başarılı durum kodu
            sendResult(selfObj, sendResultSelector, 0, product, nil)
        }
        
        // Alternatif olarak completeTransaction metodunu da tetikleyebiliriz:
        let completeSelector = NSSelectorFromString("completeTransaction:")
        if class_respondsToSelector(object_getClass(selfObj), completeSelector) {
            typealias CompleteFunc = @convention(c) (AnyObject, Selector, AnyObject) -> Void
            let completeIMP = class_getMethodImplementation(object_getClass(selfObj), completeSelector)
            let complete = unsafeBitCast(completeIMP, to: CompleteFunc.self)
            
            complete(selfObj, completeSelector, product)
        }
    }
}
