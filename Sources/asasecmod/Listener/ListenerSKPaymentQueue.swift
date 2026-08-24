import Foundation
import UIKit
import Jinx

struct ListenerSKPaymentQueue: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject?) -> Void

    let cls: AnyClass? = objc_getClass("SKPaymentQueue") as? AnyClass
    let sel: Selector = NSSelectorFromString("paymentQueue:updatedTransactions:")

    let replace: T = { selfObj, selector, transactions in
        let className = String(describing: type(of: selfObj))
        let selName = NSStringFromSelector(selector)
        
        // Ekrana hangi sınıfın ve hangi metodun tetiklendiğini basıyoruz
        AlertHelper.show(
            title: "StoreKit Genel Dinleyici",
            message: "Sınıf: \(className)\nMetot: \(selName)"
        )
        
        orig(selfObj, selector, transactions)
    }
}
