import Jinx
import UIKit

@available(iOS 15.0, *)
struct Tweak {
    static func ctor() {

        //CanPayHook().hook()
        //DelegateHook().hook()
        //TransactionHook().hook()
        //ProductHook().hook()
       // ReelShortPurchaseHook().hook()
        //ListenerSKProductsRequest().hook()
        //UniversalListener().hook()
        if let cls: AnyClass = NSClassFromString("FLEXManager") {
    // sharedManager metodunun Objective-C IMP (Function Pointer) çağrısı
    let selector = NSSelectorFromString("sharedManager")
    typealias SharedManagerFunc = @convention(c) (AnyClass, Selector) -> AnyObject
    let implementation = class_getMethodImplementation(object_getClass(cls), selector)
    let castedFunc = unsafeBitCast(implementation, to: SharedManagerFunc.self)
    let sharedManager = castedFunc(cls, selector)
    
    // showExplorer metodunu çağır
    let showSelector = NSSelectorFromString("showExplorer")
    typealias ShowExplorerFunc = @convention(c) (AnyObject, Selector) -> Void
    let showImplementation = class_getMethodImplementation(object_getClass(sharedManager), showSelector)
    let castedShowFunc = unsafeBitCast(showImplementation, to: ShowExplorerFunc.self)
    castedShowFunc(sharedManager, showSelector)
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
