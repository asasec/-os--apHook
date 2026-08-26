import Foundation
import UIKit

struct GuiAlert {

    private static var activeWindow: UIWindow?

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
    
    static func OyunaOzel(Modlu: @escaping () -> Void, Modsuz: @escaping () -> Void, mesaj: String) {
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
                message: mesaj,
                preferredStyle: .alert
            )
            
            let ModluT = UIAlertAction(title: "Modu Yamala ve Giriş Yap", style: .default) { _ in
                Modlu()
            }
            
            let StoreKitHookT = UIAlertAction(title: "Modsuz Giriş Yap", style: .default) { _ in
                Modsuz()
            }
            
            alert.addAction(ModluT)
            alert.addAction(ModsuzT)
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func SonUyari(Yapi: String, DevamEt: @escaping () -> Void, İptalEt: @escaping () -> Void) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,let rootVC = window.rootViewController else {
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
    
    @discardableResult
    public static func SaniyeliUyari(saniye: TimeInterval, mesaj: String) -> GuiAlert {
        DispatchQueue.main.async {
           
            dismiss()
            
            
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else { return }
            
            
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .alert + 1
            window.isHidden = false
            
            
            let viewController = UIViewController()
            viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            
            
            let alertBox = UIView()
            alertBox.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
            alertBox.layer.cornerRadius = 14
            alertBox.layer.shadowColor = UIColor.black.cgColor
            alertBox.layer.shadowOpacity = 0.2
            alertBox.layer.shadowOffset = CGSize(width: 0, height: 4)
            alertBox.layer.shadowRadius = 10
            alertBox.translatesAutoresizingMaskIntoConstraints = false
            
            
            let label = UILabel()
            label.text = mesaj
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
            
            
            alertBox.addSubview(label)
            viewController.view.addSubview(alertBox)
            window.rootViewController = viewController
            
            
            NSLayoutConstraint.activate([
                alertBox.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                alertBox.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
                alertBox.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
                alertBox.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
                
                label.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
                label.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: 20),
                label.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: 20)
            ])
            
            activeWindow = window
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + saniye) {
                dismiss()
            }
        }
        return GuiAlert()
    }
    
    private static func dismiss() {
        activeWindow?.isHidden = true
        activeWindow = nil
    }
}
