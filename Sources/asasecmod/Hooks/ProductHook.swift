import Jinx
import StoreKit

struct ProductHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> NSDecimalNumber

    let cls: AnyClass? = SKProduct.self
    let sel: Selector = #selector(getter: SKProduct.price)
    
    let replace: T = { selfObj, sel in
        if Preferences.isZeroPointOnePriceEnabled {
            return NSDecimalNumber(string: "0.01") // Tip uyuşmazlığı çökmesini önler
        }
        return orig(selfObj, sel)
    }
}
