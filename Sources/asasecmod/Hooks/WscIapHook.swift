import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, AnyObject?, Bool) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("payForProduct:askToBuy:")
    
    let replace: T = { selfObj, sel, product, askToBuy in
        autoreleasepool {
            guard let selfInstance = Optional(selfObj), let validProduct = product else {
                return
            }
            
            let productClass = object_getClass(validProduct)
            let className = productClass.map { String(describing: $0) } ?? "Bilinmeyen Sınıf"
            let productID = "\(validProduct)"
            
            DispatchQueue.main.async {
                AlertHelper.show(
                    title: "WscIapHook Başarılı!",
                    message: "Ürün ID: \(productID)\nSınıfı: \(className)"
                )
            }
            
            // NSCFString hatasını önlemek için completeTransaction çağrısını geçici olarak durduruyoruz
            // çünkü validProduct bir SKProduct yerine NSString (__NSCFString) olarak geliyor.
        }
    }
}
