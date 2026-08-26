import Jinx
import StoreKit

public enum StoreKit1 {
    
    public struct OdemeHook: Hook {
        public typealias T = @convention(c) (AnyObject, Selector) -> Bool

        public let cls: AnyClass? = SKPaymentQueue.self
        public let sel: Selector = #selector(SKPaymentQueue.canMakePayments)
        
        public let replace: T = { obj, sel in
            return true
        }
        
        public init() {}
        
        @discardableResult
        public static func hook() -> Bool {
            return OdemeHook().hook()
        }
    }
    
    public struct TemsilciHook: Hook {
        public typealias T = @convention(c) (AnyObject, Selector, SKProductsRequestDelegate?) -> Void

        public let cls: AnyClass? = SKProductsRequest.self
        public let sel: Selector = sel_registerName("setDelegate:")
        
        public let replace: T = { obj, sel, delegate in
            let tella: AsasecTemsilci = .shared
            if let unwrappedDelegate = delegate {
                if !tella.delegates.contains(where: { $0 === unwrappedDelegate }) {
                    tella.delegates.append(unwrappedDelegate)
                }
            }
            orig(obj, sel, tella)
        }
        
        public init() {}
        
        @discardableResult
        public static func hook() -> Bool {
            return TemsilciHook().hook()
        }
    }
    
    public struct IslemHook: HookGroup {
        public typealias T0 = @convention(c) (AnyObject, Selector) -> SKPaymentTransactionState
        public typealias T1 = @convention(c) (AnyObject, Selector) -> String?
        public typealias T2 = @convention(c) (AnyObject, Selector) -> String?
        public typealias T3 = @convention(c) (AnyObject, Selector) -> Error?
        public typealias T4 = @convention(c) (AnyObject, Selector) -> Date?

        public let cls: AnyClass? = SKPaymentTransaction.self

        public let sel0: Selector = #selector(getter: SKPaymentTransaction.transactionState)
        public let sel1: Selector = sel_registerName("matchingIdentifier")
        public let sel2: Selector = #selector(getter: SKPaymentTransaction.transactionIdentifier)
        public let sel3: Selector = #selector(getter: SKPaymentTransaction.error)
        public let sel4: Selector = #selector(getter: SKPaymentTransaction.transactionDate)

        public let replace0: T0 = { obj, sel in
            return .purchased
        }
        
        public let replace1: T1 = { obj, sel in
            return UUID().uuidString
        }
        
        public let replace2: T2 = { obj, sel in
            return UUID().uuidString
        }
        
        public let replace3: T3 = { obj, sel in
            return nil
        }
        
        public let replace4: T4 = { obj, sel in
            return Date()
        }
        
        public init() {}
        
        @discardableResult
        public static func hook() -> Bool {
            return IslemHook().hook()
        }
    }
}
