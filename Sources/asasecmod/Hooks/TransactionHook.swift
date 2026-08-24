import Jinx
import StoreKit

struct TransactionHook: HookGroup {
    typealias T0 = @convention(c) (AnyObject, Selector) -> SKPaymentTransactionState
    typealias T1 = @convention(c) (AnyObject, Selector) -> String?
    typealias T2 = @convention(c) (AnyObject, Selector) -> String?
    typealias T3 = @convention(c) (AnyObject, Selector) -> Error?
    typealias T4 = @convention(c) (AnyObject, Selector) -> Date?

    let cls: AnyClass? = SKPaymentTransaction.self

    let sel0: Selector = #selector(getter: SKPaymentTransaction.transactionState)
    let sel1: Selector = sel_registerName("matchingIdentifier")
    let sel2: Selector = #selector(getter: SKPaymentTransaction.transactionIdentifier)
    let sel3: Selector = #selector(getter: SKPaymentTransaction.error)
    let sel4: Selector = #selector(getter: SKPaymentTransaction.transactionDate)

    let replace0: T0 = { obj, sel in
        if !Preferences.isFreePurchaseEnabled {
            return orig(obj, sel)
        }
        return .purchased
    }
    
    let replace1: T1 = { obj, sel in
        if !Preferences.isFreePurchaseEnabled {
            return orig(obj, sel)
        }
        return UUID().uuidString
    }
    
    let replace2: T2 = { obj, sel in
        if !Preferences.isFreePurchaseEnabled {
            return orig(obj, sel)
        }
        return UUID().uuidString
    }
    
    let replace3: T3 = { obj, sel in
        if !Preferences.isFreePurchaseEnabled {
            return orig(obj, sel)
        }
        return nil
    }
    
    let replace4: T4 = { obj, sel in
        if !Preferences.isFreePurchaseEnabled {
            return orig(obj, sel)
        }
        return Date()
    }
}
