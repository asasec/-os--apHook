import Jinx
import StoreKit

struct CanPayHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> Bool

    let cls: AnyClass? = SKPaymentQueue.self
    let sel: Selector = #selector(SKPaymentQueue.canMakePayments)
    
    let replace: T = { obj, sel in
        /*if !Preferences.isFreePurchaseEnabled {
            return orig(obj, sel) // Kapalıysa orijinal sonuca karışma
        }*/
        return true // Açıksa her zaman true dön
    }
}
