import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject, Bool) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("payForProduct:askToBuy:")
    
    let replace: T = { selfObj, sel, product, askToBuy in
        // Çökme riskini önlemek için güvenli optional kontrolü (AnyObject -> Optional cast)
        guard let validProduct = product as? NSObject else {
            DispatchQueue.main.async {
                AlertHelper.show(
                    title: "Hata!", 
                    message: "Satın alma başarısız: Ürün bilgisi (product) boş veya geçersiz."
                )
            }
            return
        }
        
        let productName = String(describing: validProduct)
        
        // UI işlemlerinin güvenli çalışması için ana thread üzerine alıyoruz
        DispatchQueue.main.async {
            AlertHelper.show(
                title: "Hile Aktif!", 
                message: "Ürün başarıyla satın alındı simüle ediliyor:\n\(productName)"
            )
        }
        
        // 1. IOSIAP sınıfının kendi içindeki başarılı sonuç fonksiyonunu tetikleyelim
        let sendResultSelector = NSSelectorFromString("sendResult:forProduct:andPayload:")
        if class_respondsToSelector(object_getClass(selfObj), sendResultSelector) {
            typealias SendResultFunc = @convention(c) (AnyObject, Selector, Int32, AnyObject, AnyObject?) -> Void
            let sendResultIMP = class_getMethodImplementation(object_getClass(selfObj), sendResultSelector)
            let sendResult = unsafeBitCast(sendResultIMP, to: SendResultFunc.self)
            
            // 0 -> Başarılı durum kodu
            sendResult(selfObj, sendResultSelector, 0, validProduct, nil)
        }
        
        // 2. completeTransaction metodunu da tetikleyelim
        let completeSelector = NSSelectorFromString("completeTransaction:")
        if class_respondsToSelector(object_getClass(selfObj), completeSelector) {
            typealias CompleteFunc = @convention(c) (AnyObject, Selector, AnyObject) -> Void
            let completeIMP = class_getMethodImplementation(object_getClass(selfObj), completeSelector)
            let complete = unsafeBitCast(completeIMP, to: CompleteFunc.self)
            
            complete(selfObj, completeSelector, validProduct)
        }
    }
}
