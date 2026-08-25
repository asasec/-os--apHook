import UIKit
import Jinx

struct IAPSuccessHook: Hook {
    // Metodun imza türü: Argüman sayısına ve türlerine göre c convention tanımı
    // (self, sel, message, addConis, sku, price, orderId, transationId, orderModel, check_order_status, appleError, businessError, payStep) vb.
    typealias T = @convention(c) (AnyObject, Selector, Int, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, Int, AnyObject, AnyObject, AnyObject) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IAPManagerV2")
    let sel: Selector = NSSelectorFromString("buyResultsCode:message:addConis:sku:price:orderId:transationId:orderModel:check_order_status:appleError:businessError:payStep:")
    
    let replace: T = { selfObj, sel, resultCode, message, addConis, sku, price, orderId, transationId, orderModel, checkOrderStatus, appleError, businessError, payStep in
        
        // Önce orijinal fonksiyonu çalıştıralım ki uygulama kendi akışından kopmasın
        orig(selfObj, sel, resultCode, message, addConis, sku, price, orderId, transationId, orderModel, checkOrderStatus, appleError, businessError, payStep)
        
        let productSku = String(describing: sku)
        let coinsToAdd = String(describing: addConis)
        let status = String(checkOrderStatus)
        
        let alertMsg = "SKU: \(productSku)\nEklenecek Jeton (addConis): \(coinsToAdd)\nDurum Kodu (status): \(status)"
        
        // Sonuç metodunun tetiklendiğini ekranda görelim
        AlertHelper.show(title: "BuyResults Yakalandı!", message: alertMsg)
    }
}
