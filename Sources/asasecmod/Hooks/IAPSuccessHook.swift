import UIKit
import Jinx

struct IAPSuccessHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject, AnyObject, Int, AnyObject, AnyObject) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IAPManagerV2")
    let sel: Selector = NSSelectorFromString("requestBuyProductId:gid:price:is_quick_buy:reportModel:extensionModel:")
    
    let replace: T = { selfObj, sel, gid, price, is_quick_buy, reportModel, extensionModel in
        // Orijinal akışı çağırıyoruz (isteğin gitmesi gerekiyorsa gitsin)
        orig(selfObj, sel, gid, price, is_quick_buy, reportModel, extensionModel)
        
        let productId = String(describing: gid)
        AlertHelper.show(title: "Talep Yakalandı", message: "Ürün: \(productId)\nBaşarı tetikleniyor...")
        
        // Şimdi IAPManagerV2 içindeki başarı metodunu (v2_purchaseSuccessWithTransactionId) manuel tetikleyelim
        let successSelector = NSSelectorFromString("v2_purchaseSuccessWithTransactionId:orderId:sku:originalId:iapWays:completion:")
        
        if class_getInstanceMethod(object_getClass(selfObj), successSelector) != nil {
            // Swift/ObjC runtime üzerinden başarı fonksiyonunu çağırıyoruz
            let fakeTransactionId = NSString(string: "fake_trans_123456")
            let fakeOrderId = NSString(string: "fake_order_78910")
            let sku = gid // Ürün ID'sini SKU olarak veriyoruz
            let originalId = NSString(string: "fake_orig_123")
            let iapWays = 1 // Ödeme yöntemi türü (Apple StoreKit vb.)
            
            // Metodu dinamik olarak çağırıyoruz (objc_msgSend alternatifi veya performSelector)
            typealias SuccessFunc = @convention(c) (AnyObject, Selector, AnyObject, AnyObject, AnyObject, AnyObject, Int, AnyObject?) -> Void
            let successImp = unsafeBitCast(class_getMethodImplementation(object_getClass(selfObj), successSelector), to: SuccessFunc.self)
            
            // Başarı fonksiyonunu sahte verilerle tetikle
            successImp(selfObj, successSelector, fakeTransactionId, fakeOrderId, sku, originalId, iapWays, nil)
        }
    }
}
