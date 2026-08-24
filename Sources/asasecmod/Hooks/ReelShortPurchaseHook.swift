import Foundation
import UIKit
import Jinx

struct ReelShortPurchaseHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, NSString, NSString, NSString, NSString, NSString, AnyObject?) -> Void

    let cls: AnyClass? = objc_getClass("RSStoreKitV2Manager")
    let sel: Selector = NSSelectorFromString("v2_purchaseSuccessWithTransactionId:orderId:sku:originalId:iapWayS:completion:")

    let replace: T = { selfObj, selector, txId, orderId, sku, originalId, iapWayS, completion in
        let skuString = sku as String
        
        // Ekranda UIAlertController ile göster
        AlertHelper.show(title: "Jinx Hook Başarılı!", message: "Satın alma yakalandı!\nSKU: \(skuString)")
        
        // Orijinal işleyişe devam etmesi için fonksiyonu tetikliyoruz
        orig(selfObj, selector, txId, orderId, sku, originalId, iapWayS, completion)
    }
}
