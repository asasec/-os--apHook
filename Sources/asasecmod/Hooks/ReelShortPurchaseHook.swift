import Foundation
import UIKit
import Jinx

struct ReelShortPurchaseHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, NSString, NSString, NSString, NSString, NSString, AnyObject?) -> Void

    let cls: AnyClass? = objc_getClass("RSStoreKitV2Manager") as? AnyClass
    let sel: Selector = NSSelectorFromString("v2_purchaseSuccessWithTransactionId:orderId:sku:originalId:iapWayS:completion:")

    let replace: T = { selfObj, selector, txId, orderId, sku, originalId, iapWayS, completion in
        // Nesnenin gerçek sınıf adını runtime üzerinden alıyoruz
        let className = String(describing: type(of: selfObj))
        let skuString = sku as String
        
        // Ekrana hem sınıf adını hem de yakalanan SKU'yu basıyoruz
        AlertHelper.show(
            title: "Hook Yakaladı!",
            message: "Sınıf: \(className)\nSKU: \(skuString)"
        )
        
        orig(selfObj, selector, txId, orderId, sku, originalId, iapWayS, completion)
    }
}
