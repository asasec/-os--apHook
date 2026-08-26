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
               
                  GuiAlert.SaniyeliUyari(saniye: 3, mesaj: "Flex Arayüzü Açılıyor")
               
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  
                     FLEXManager.shared.showExplorer()
                     
                  }           
                  
               },
               
               StoreKitHook: {
                  
                  GuiAlert.SaniyeliUyari(saniye: 3, mesaj: "StoreKit-1 Sistem Frameworkuna Yama Uygulanıyor")
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  
                     StoreKit1.OdemeHook().hook()
                     StoreKit1.TemsilciHook().hook()
                     StoreKit1.IslemHook().hook()
                     
                     GuiAlert.SaniyeliUyari(saniye: 3, mesaj: "StoreKit-1 Sistem Frameworku Yaması Uygulandı")
                     
                  }
                  
               },
               
               Kapat: {
               
                  GuiAlert.SaniyeliUyari(saniye: 3, mesaj: "Direkt Sonlandırıldı")
                  
               }
            )
        }
        
        //Oyuna Ozel
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            
            GuiAlert.OyunaOzel(
            
               Modlu: {
               
                  GuiAlert.SaniyeliUyari(saniye: 3, mesaj: "Mod Yaması Uygulanıyor")
               
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  
                     //Mod
                     
                     GuiAlert.SaniyeliUyari(saniye: 3, mesaj: "Mod Yaması Uygulandı")
                     
                  }           
                  
               },
               
               Modsuz: {
                  
                  GuiAlert.SaniyeliUyari(saniye: 3, mesaj: "Modsuz Devam Ediliyor")
                  
               },
               
               mesaj: " Oyuna ozel Mod surum "
               
            )
        }*/

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
