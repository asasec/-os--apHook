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
               
                  GuiAlert.SaniyeliUyari(baslik: "FLEX", mesaj: "\nFlex Arayüzü Açılıyor\n", saniye: 3)
               
                  DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                  
                     FLEXManager.shared.showExplorer()
                     
                  }           
                  
               },

               Dinleyici: {
               
                  GuiAlert.SaniyeliUyari(baslik: "İşlemde", mesaj: "\nDinleme ile İlgili Sistem Frameworkuna Yama Uygulanıyor\n", saniye: 6)
                
                  DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                  
                     GuiAlert.DinleyiciMenu(baslik: "Dinleyici Menü")

                  }
                  
               },
               
               StoreKitHook: {
                  
                  GuiAlert.SaniyeliUyari(baslik: "İşlemde", mesaj: "\nStoreKit-1 Sistem Frameworkuna Yama Uygulanıyor\n", saniye: 5)
                
                  DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
                  
                     StoreKit1.OdemeHook().hook()
                     StoreKit1.TemsilciHook().hook()
                     StoreKit1.IslemHook().hook()
                     
                     GuiAlert.SaniyeliUyari(baslik: "Başarılı", mesaj: "\nStoreKit-1 Sistem Frameworkuna Yama Uygulandı\n", saniye: 4)
                     
                  }
                  
               },
                
               Kapat: {
               
                  GuiAlert.SaniyeliUyari(baslik: "Uyarı", mesaj: "\nDirekt Durduruldu, İşlemsiz Geçildi\n", saniye: 4)
                  
               }
            )
        }
        
        //Oyuna Ozel
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            
            GuiAlert.OyunaOzel(
            
               Modlu: {
               
                  GuiAlert.SaniyeliUyari(baslik: "İşlemde", mesaj: "Yama Uygulanıyor", saniye: 4)
               
                  DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                  
                     //Mod
                     
                     GuiAlert.SaniyeliUyari(baslik: "Başarılı", mesaj: "Yama Uygulandı", saniye: 4)
                     
                  }           
                  
               },
               
               Modsuz: {
                  
                  GuiAlert.SaniyeliUyari(baslik: "Uyarı", mesaj: "Yama Uygulanmadan Giriliyor", saniye: 3)
                  
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
