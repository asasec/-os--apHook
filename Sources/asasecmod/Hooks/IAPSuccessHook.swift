import UIKit
import Jinx

// Jinx kütüphanesi ile satın alma isteği metoduna hook atma
struct IAPSuccessHook: Hook {
    // Metodun imza türü: (self, selector, gid, price, is_quick_buy, reportModel, extensionModel)
    typealias T = @convention(c) (AnyObject, Selector, AnyObject, AnyObject, Int, AnyObject, AnyObject) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IAPManagerV2")
    let sel: Selector = NSSelectorFromString("requestBuyProductId:gid:price:is_quick_buy:reportModel:extensionModel:")
    
    let replace: T = { selfObj, sel, gid, price, is_quick_buy, reportModel, extensionModel in
        // Orijinal fonksiyonun çalışmasını engellemiyoruz
        orig(selfObj, sel, gid, price, is_quick_buy, reportModel, extensionModel)
        
        let productId = String(describing: gid)
        let productPrice = String(describing: price)
        
        let message = "Ürün ID (gid): \(productId)\nFiyat: \(productPrice)"
        
        // Butona basıldığı an ekranda alert gösteriyoruz
        AlertHelper.show(title: "Satın Alma Talebi Yakalandı!", message: message)
    }
}

