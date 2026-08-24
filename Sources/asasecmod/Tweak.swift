import Jinx
import UIKit

@available(iOS 15.0, *)
struct Tweak {
    static func ctor() {

        CanPayHook().hook()
        DelegateHook().hook()
        TransactionHook().hook()
        ProductHook().hook()

        do {
                try ReelShortPurchaseHook().hook()
                // Başarılı yükleme durumunu ekranda göster
                AlertHelper.show(title: "Tweak Yüklendi", message: "ReelShort Jinx hook başarıyla aktif edildi!")
            } catch {
                // Hata durumunu ekranda göster
                AlertHelper.show(title: "Tweak Hatası", message: "Hook yüklenemedi: \(error.localizedDescription)")
            }
        
        // Eğer projenizde Preferences tanımlı değilse bu kısımları kaldırabilirsiniz
        // veya projenizdeki ayarlara göre uyarlayabilirsiniz.
        
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
    
    private static func showMenu() {
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
    }
} // <-- Eksik olan struct kapanış parantezi eklendi

@_cdecl("jinx_entry")
func jinxEntry() {
    if #available(iOS 15.0, *) {
        Tweak.ctor()
    }
}
