import Jinx
import StoreKit

struct DelegateHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, SKProductsRequestDelegate?) -> Void

    let cls: AnyClass? = SKProductsRequest.self
    let sel: Selector = sel_registerName("setDelegate:")
    
    let replace: T = { obj, sel, delegate in
        let tella: AsasecDelegate = .shared
        if let unwrappedDelegate = delegate {
            // Bellek sızıntısını önlemek için aynı delegate tekrar ekleniyorsa ekleme
            if !tella.delegates.contains(where: { $0 === unwrappedDelegate }) {
                tella.delegates.append(unwrappedDelegate)
            }
        }
        orig(obj, sel, tella)
    }
}
