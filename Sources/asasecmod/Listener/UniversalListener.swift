import Foundation
import UIKit
import Jinx

struct UniversalListener: Hook {
    typealias T = @convention(c) (AnyObject, Selector, Selector, AnyObject?, AnyObject?) -> Bool

    // UIApplication üzerindeki hedef aksiyon iletici metodunu hook'luyoruz
    let cls: AnyClass? = objc_getClass("UIApplication") as? AnyClass
    let sel: Selector = NSSelectorFromString("sendAction:to:from:forEvent:")

    let replace: T = { selfObj, selector, action, target, sender, event in
        let actionName = NSStringFromSelector(action)
        let targetName = target != nil ? String(describing: type(of: target!)) : "Nil"
        let senderName = sender != nil ? String(describing: type(of: sender!)) : "Nil"
        
        // Ekrana basılan butonun tetiklediği aksiyonu ve hedefi yazdırıyoruz
        AlertHelper.show(
            title: "Evrensel Aksiyon Yakalandı!",
            message: "Aksiyon: \(actionName)\nHedef: \(targetName)\nGönderen: \(senderName)"
        )
        
        return orig(selfObj, selector, action, target, sender, event)
    }
}
