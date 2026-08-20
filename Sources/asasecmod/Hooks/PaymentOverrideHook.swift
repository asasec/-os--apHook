import Jinx
import StoreKit

struct PaymentOverrideHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> NSString

    let cls: AnyClass? = SKPayment.self
    let sel: Selector = #selector(getter: SKPayment.productIdentifier)
    
    let replace: T = { obj, sel in
        let originalID = orig(obj, sel) as String
        
        if Preferences.isFreePurchaseEnabled {
            // Tıklanan ürünün ID'sini ekranda uyarı penceresi olarak gösterir
            if !originalID.isEmpty {
                // Not: UI işlemleri ana thread (main thread) üzerinde yapılmalıdır
                DispatchQueue.main.async {
                    AlertHelper.show(title: "Tıklanan Ürün ID", message: originalID)
                }
            }
            
            // Çalışan sağlam ID'yi buraya yazabilirsiniz:
            let workingProductID = "buraya_calisan_id_gelecek"
            
            if !originalID.isEmpty {
                return workingProductID as NSString
            }
        }
        
        return originalID as NSString
    }
}
