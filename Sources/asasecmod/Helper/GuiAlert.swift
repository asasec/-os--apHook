import Foundation
import UIKit

struct GuiAlert {

    static func BilgiAktar(baslik: String, mesaj: String) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            var topController = rootVC
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func BaslangicEkrani(FlexGui: @escaping () -> Void, StoreKitHook: @escaping () -> Void, Kapat: @escaping () -> Void) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            var topController = rootVC
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            let alert = UIAlertController(
                title: "@asasecmod",
                message: nil,
                preferredStyle: .alert
            )
            
            let FlexGuiT = UIAlertAction(title: "FLEX Arayüzünü Aç", style: .default) { _ in
                FlexGui()
            }
            
            let StoreKitHookT = UIAlertAction(title: "StoreKit-1 Satın Almaları Yamala", style: .default) { _ in
                StoreKitHook()
            }
            
            let KapatT = UIAlertAction(title: "Menüyü Kapat", style: .cancel) { _ in
                Kapat()
            }
            
            alert.addAction(FlexGuiT)
            alert.addAction(StoreKitHookT)
            alert.addAction(KapatT)
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func BaslangicEkrani(Yapi: String, DevamEt: @escaping () -> Void, İptalEt: @escaping () -> Void) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            var topController = rootVC
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            let alert = UIAlertController(
                title: "@asasecmod",
                message: "Emin Misin?\nDevam Etmek İstediğin Yapı: \(Yapi)",
                preferredStyle: .alert
            )
            
            let DevamEtT = UIAlertAction(title: "Devam Et", style: .default) { _ in
                DevamEt()
            }
            
            let İptalEtT = UIAlertAction(title: "Vazgeç", style: .default) { _ in
                İptalEt()
            }
            
            alert.addAction(DevamEtT)
            alert.addAction(İptalEtT)
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
}
