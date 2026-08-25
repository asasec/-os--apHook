import UIKit
import Jinx

// Jinx kütüphanesi ile IAPManagerV2 metoduna hook atma yapısı
struct IAPSuccessHook: Hook {
    // Metodun imza türü (self, selector, transactionId, orderId, sku, originalId, iapWays, completion)
    typealias T = @convention(c) (AnyObject, Selector, AnyObject, AnyObject, AnyObject, AnyObject, Int, AnyObject) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IAPManagerV2")
    let sel: Selector = NSSelectorFromString("v2_purchaseSuccessWithTransactionId:orderId:sku:originalId:iapWays:completion:")
    
    let replace: T = { selfObj, sel, transactionId, orderId, sku, originalId, iapWays, completion in
        // Orijinal fonksiyonun akışını devam ettiriyoruz
        orig(selfObj, sel, transactionId, orderId, sku, originalId, iapWays, completion)
        
        // Gelen verileri string'e dönüştürüyoruz
        let tId = String(describing: transactionId)
        let productSku = String(describing: sku)
        
        let message = "Transaction ID: \(tId)\nSKU: \(productSku)"
        
        // Doğrudan verdiğiniz AlertHelper yapısını kullanıyoruz
        AlertHelper.show(title: "IAP Başarılı (Jinx Hook)", message: message)
    }
}
