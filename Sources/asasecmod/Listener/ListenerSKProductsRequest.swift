import Foundation
import UIKit
import Jinx

struct ListenerSKProductsRequest: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject?) -> Void

    // Ürün isteklerini yapan temel StoreKit sınıfı
    let cls: AnyClass? = objc_getClass("SKProductsRequest") as? AnyClass
    let sel: Selector = NSSelectorFromString("initWithProductIdentifiers:")

    let replace: T = { selfObj, selector, productIdentifiers in
        let className = String(describing: type(of: selfObj))
        
        // Ekrana ürün talebinin ulaştığını yazdırıyoruz
        AlertHelper.show(
            title: "StoreKit Ürün İsteği Yakalandı!",
            message: "Sınıf: \(className)\nIDs: \(String(describing: productIdentifiers))"
        )
        
        orig(selfObj, selector, productIdentifiers)
    }
}
