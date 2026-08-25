import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    // sendResult:forProduct:andPayload: imza yapısı: (int) forProduct:(id) andPayload:(id) -> v@:i@@
    typealias T = @convention(c) (AnyObject, Selector, Int32, AnyObject?, AnyObject?) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("sendResult:forProduct:andPayload:")
    
    let replace: T = { selfObj, sel, resultCode, product, payload in
        autoreleasepool {
            // resultCode değerini 0 (başarılı) olarak zorluyoruz
            let forcedResultCode: Int32 = 0 
            
            DispatchQueue.main.async {
                AlertHelper.show(
                    title: "Başarılı Satın Alım!",
                    message: "Hile devreye girdi, işlem ücretsiz onaylandı."
                )
            }
            
            // Orijinal metodun akışını bozmamak için orijinal IMP çağrısı eklenebilir
        }
    }
}
