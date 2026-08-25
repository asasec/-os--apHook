import UIKit
import Jinx

struct IAPSuccessHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, Int, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, Int, AnyObject, AnyObject, AnyObject) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IAPManagerV2")
    let sel: Selector = NSSelectorFromString("buyResultsCode:message:addConis:sku:price:orderId:transationId:orderModel:check_order_status:appleError:businessError:payStep:")
    
    let replace: T = { selfObj, sel, resultCode, message, addConis, sku, price, orderId, transationId, orderModel, checkOrderStatus, appleError, businessError, payStep in
        
        let productSku = String(describing: sku).lowercased()
        
        // Önce orijinal satın alma fonksiyonunu çalıştırıyoruz
        orig(selfObj, sel, resultCode, message, addConis, sku, price, orderId, transationId, orderModel, checkOrderStatus, appleError, businessError, payStep)
        
        // UserAccount sınıfını alıyoruz
        let userAccountClass: AnyClass? = objc_lookUpClass("UserAccount")
        
        if productSku.contains("vip") || productSku.contains("sub") {
            AlertHelper.show(title: "VIP Aktifleştirildi", message: "Ürün: \(productSku)\nVIP statüsü zorlanıyor...")
            
            // Eğer UserAccount sınıfında VIP durumunu set eden metot varsa,
            // Bellekteki nesneleri manipüle etmek için setVip_status ve setVip_expire tetiklenir.
            let setVipStatusSel = NSSelectorFromString("setVip_status:")
            let setVipExpireSel = NSSelectorFromString("setVip_expire:")
            
            typealias SetVipStatusFunc = @convention(c) (AnyObject, Selector, NSInteger) -> Void
            
            // Not: Uygulama içerisinde UserAccount nesnesini bulup imp üzerinden çağırabiliriz.
            // Veya aşağıda paylaşılan UserAccount hook'u ile her hesap güncellemesinde otomatik aktif olur.
            
        } else {
            let forcedCoins: NSUInteger = 99999
            AlertHelper.show(title: "Jeton Yüklendi", message: "Ürün: \(productSku)\nEklenen Jeton: \(forcedCoins)")
            
            let setCoinsSel = NSSelectorFromString("setCoins:")
            typealias SetCoinsFunc = @convention(c) (AnyObject, Selector, NSUInteger) -> Void
            
            if let userClass = userAccountClass {
                // Eğer sınıf metodu veya paylaşılan bir instance varsa buradan müdahale edilebilir.
            }
        }
        
        // Sunucu ve arayüz senkronizasyonu
        let accountServiceClass: AnyClass? = objc_lookUpClass("RSNCoreBridgeAccountService")
        let getUserInfoSelector = NSSelectorFromString("cms_getUserInfo")
        if let serviceClass = accountServiceClass, class_respondsToSelector(serviceClass, getUserInfoSelector) {
            typealias GetUserInfoFunc = @convention(c) (AnyClass, Selector) -> Void
            let imp = unsafeBitCast(class_getMethodImplementation(object_getClass(serviceClass), getUserInfoSelector), to: GetUserInfoFunc.self)
            imp(serviceClass, getUserInfoSelector)
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("UserBalanceDidChangeNotification"), object: nil)
        }
    }
}

// Alternatif ve daha kesin çözüm: Doğrudan UserAccount nesnesi her oluşturulduğunda veya güncellendiğinde değerleri zorlamak
struct UserAccountOverrideHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, NSUInteger) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("UserAccount")
    let sel: Selector = NSSelectorFromString("setCoins:")
    
    let replace: T = { selfObj, sel, coins in
        // Uygulama her coin set etmeye çalıştığında bunu 99999 yapalım
        let hackedCoins: NSUInteger = 99999
        orig(selfObj, sel, hackedCoins)
    }
}

struct UserAccountVipOverrideHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, NSInteger) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("UserAccount")
    let sel: Selector = NSSelectorFromString("setVip_status:")
    
    let replace: T = { selfObj, sel, status in
        // VIP durumunu her zaman aktif (1) yapalım
        let activeVip: NSInteger = 1
        orig(selfObj, sel, activeVip)
    }
}
