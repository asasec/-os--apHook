import Foundation
import UIKit
import Jinx

struct WscIapHook: Hook {
    // IOSIAP sınıfının payForProduct:askToBuy: metodunun imtiyazı
    typealias T = @convention(c) (AnyObject, Selector, AnyObject, Bool) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("IOSIAP")
    let sel: Selector = NSSelectorFromString("payForProduct:askToBuy:")
    
    let replace: T = { selfObj, sel, product, askToBuy in
        // Ürün objesini string veya description olarak yakalayalım
        let productName = String(describing: product)
        
        // Doğrudan senin AlertHelper ile ekrana uyarı bastırıyoruz
        AlertHelper.show(
            title: "WscIapHook Başarılı!", 
            message: "Satın alma yakalandı!\nÜrün: \(productName)"
        )
        
        // Orijinal fonksiyonu çağır (istersen çağrılmayabilir de, deneyerek görebilirsin)
        // orig(selfObj, sel, product, askToBuy)
    }
}
