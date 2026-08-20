import Jinx
import StoreKit

struct PaymentOverrideHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> NSString

    let cls: AnyClass? = SKPayment.self
    let sel: Selector = #selector(getter: SKPayment.productIdentifier)
    
    let replace: T = { obj, sel in
        let originalID = orig(obj, sel) as String
        
        if Preferences.isFreePurchaseEnabled {
            // Çalışan sağlam ana ürün ID'sini buraya sabitliyoruz:
            let workingProductID = "iap_bux_ultimate"
            
            if !originalID.isEmpty && originalID != workingProductID {
                return workingProductID as NSString
            }
        }
        
        return originalID as NSString
    }
}
