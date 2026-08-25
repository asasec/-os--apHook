import UIKit
import Jinx

struct IAPSuccessHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, Int, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, AnyObject, Int, AnyObject, AnyObject, AnyObject) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IAPManagerV2")
    let sel: Selector = NSSelectorFromString("buyResultsCode:message:addConis:sku:price:orderId:transationId:orderModel:check_order_status:appleError:businessError:payStep:")
    
    let replace: T = { selfObj, sel, resultCode, message, addConis, sku, price, orderId, transationId, orderModel, checkOrderStatus, appleError, businessError, payStep in
        
        let productSku = String(describing: sku).lowercased()
        
        // Orijinal satın alma fonksiyonunu çalıştırıyoruz
        orig(selfObj, sel, resultCode, message, addConis, sku, price, orderId, transationId, orderModel, checkOrderStatus, appleError, businessError, payStep)
        
        AlertHelper.show(title: "İşlem Başarılı", message: "Ürün işlendi: \(productSku)")
        
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

// Jeton miktarını doğrudan manipüle eden hook
struct UserAccountCoinsOverrideHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, Int) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("UserAccount")
    let sel: Selector = NSSelectorFromString("setCoins:")
    
    let replace: T = { selfObj, sel, coins in
        // Jeton değerini istediğimiz yüksek bir rakama sabitliyoruz
        let hackedCoins: Int = 99999
        orig(selfObj, sel, hackedCoins)
    }
}

// Ödül jeton miktarını manipüle eden hook
struct UserAccountBonusOverrideHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, Int) -> Void
    
    let cls: AnyClass? = objc_lookupClass("UserAccount")
    let sel: Selector = NSSelectorFromString("setBonus:")
    
    let replace: T = { selfObj, sel, bonus in
        let hackedBonus: Int = 99999
        orig(selfObj, sel, hackedBonus)
    }
}

// VIP durumunu aktif eden hook
struct UserAccountVipOverrideHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, Int) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("UserAccount")
    let sel: Selector = NSSelectorFromString("setVip_status:")
    
    let replace: T = { selfObj, sel, status in
        let activeVip: Int = 1
        orig(selfObj, sel, activeVip)
    }
}
