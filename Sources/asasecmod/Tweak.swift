import Foundation
import UIKit
import Jinx
import FLEX

@available(iOS 15.0, *)
struct Tweak {
    static func ctor() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            
            GuiAlert.BaslangicEkrani(
               FlexGui: {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                     FLEXManager.shared.showExplorer()
                  }
               },
               
               StoreKitHook: {
                  CanPayHook().hook()
                  DelegateHook().hook()
                  TransactionHook().hook()
                  IAPSuccessHook().hook()
                  UserAccountOverrideHook().hook()
                  UserAccountVipOverrideHook().hook()
                  
                  GuiAlert.BilgiAktar(baslik: "StoreKit-1", mesaj: "Yama Uygulandı")
               },
               
               Kapat: {
                  GuiAlert.BilgiAktar(baslik: "Durduruldu", mesaj: "Uygulama veya Oyun kapatılıp açılana kadar durduruldu")
               }
            )
        }

        // İlk açılışta menüyü ekle
       /* showMenu()
        
        // Oyundan çık-gir yapıldığında veya sahneler arası geçişte kaybolmayı önlemek için
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            showMenu()
        }*/
    }
    
    /*private static func showMenu() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            // AsasecController kullanılarak menü ekleniyor
            let controller = AsasecController.shared
            if controller.parent == nil {
                rootVC.add(controller)
            }
        }
    }*/
}

@_cdecl("jinx_entry")
func jinxEntry() {
    if #available(iOS 15.0, *) {
        Tweak.ctor()
    }
}
