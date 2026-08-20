import Jinx
import StoreKit

struct ProductHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> NSDecimalNumber

    let cls: AnyClass? = SKProduct.self
    let sel: Selector = #selector(getter: SKProduct.price)
    
    var replace: T {
        return { selfObj, sel in
            // Eğer özellik açıksa fiyatı 0.01 yap
            if Preferences.isZeroPointOnePriceEnabled {
                return 0.01
            }
            // Kapalıysa orijinal fonksiyonu çağır
            return orig(selfObj, sel)
        }
    }
}
