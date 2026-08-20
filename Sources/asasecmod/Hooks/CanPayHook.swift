import Jinx
import StoreKit

struct CanPayHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> Bool

    let cls: AnyClass? = SKPaymentQueue.self
    let sel: Selector = #selector(SKPaymentQueue.canMakePayments)
    
    let replace: T = { obj, sel in
        if !Preferences.isFreePurchaseEnabled {
            // Kapalıyken orjinal metod yerine güvenli true dönmek çöküşleri engeller
            return true
        }
        return true
    }
}
