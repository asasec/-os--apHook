import Foundation
import UIKit
import Jinx

struct ReelShortPurchaseHook: Hook {
    // vc_onActionButton metodunun imza karşılığı (self, selector, sender)
    typealias T = @convention(c) (AnyObject, Selector, AnyObject?) -> Void

    let cls: AnyClass? = objc_getClass("RSVipCenterPlanSelectorView") as? AnyClass
    let sel: Selector = NSSelectorFromString("vc_onActionButton:")

    let replace: T = { selfObj, selector, sender in
        let className = String(describing: type(of: selfObj))
        
        // Ekrana butonun yakalandığını ve sınıf adını basıyoruz
        AlertHelper.show(
            title: "VIP Butonu Yakalandı! 🎉",
            message: "Sınıf: \(className)\nMetot: vc_onActionButton"
        )
        
        // Orijinal fonksiyonu tetikle (istersen burada atlayabilir veya değiştirebilirsin)
        orig(selfObj, selector, sender)
    }
}
