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
    
    static func BaslangicEkrani(
        
        FlexGui: @escaping () -> Void,
        Dinleyici: @escaping () -> Void,
        StoreKitHook: @escaping () -> Void,
        Kapat: @escaping () -> Void

    ) {

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

            let FlexGuiT = UIAlertAction(
                title: "FLEX Arayüzünü Aç",
                style: .default
            ) { _ in

                FlexGui()

            }

            let DinleyiciT = UIAlertAction(
                title: "Buton Dinleyiciyi Aç",
                style: .default
            ) { _ in

                Dinleyici()

            }

            let StoreKitHookT = UIAlertAction(
                title: "StoreKit-1 Satın Almaları Yamala",
                style: .default
            ) { _ in

                StoreKitHook()

            }

            let KapatT = UIAlertAction(
                title: "Menüyü Kapat",
                style: .cancel
            ) { _ in

                Kapat()

            }

            alert.addAction(FlexGuiT)
            alert.addAction(DinleyiciT)
            alert.addAction(StoreKitHookT)
            alert.addAction(KapatT)

            topController.present(
                alert,
                animated: true,
                completion: nil
            )

        }
    }

    static func DinleyiciMenu(
        
        baslik: String

    ) {

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

                title: baslik,
                message: nil,
                preferredStyle: .alert

            )

            let ButonDinleT = UIAlertAction(
                title: "Buton Dinleyiciyi Aç",
                style: .default
            ) { _ in

                ButonDinleyici.DinlemeyeBasla()

            }

            let SliderDinleT = UIAlertAction(
                title: "Slider Dinleyiciyi Aç",
                style: .default
            ) { _ in

                SliderDinleyici.DinlemeyeBasla()

            }

            let SwitchDinleT = UIAlertAction(
                title: "Switch Dinleyiciyi Aç",
                style: .default
            ) { _ in

                SwitchDinleyici.DinlemeyeBasla()

            }

            let TextFieldDinleT = UIAlertAction(
                title: "TextField Dinleyiciyi Aç",
                style: .default

            ) { _ in

                TextFieldDinleyici.DinlemeyeBasla()

            }

            let SegmentedDinleT = UIAlertAction(
                title: "Segment Dinleyiciyi Aç",
                style: .default
            ) { _ in

                SegmentedDinleyici.DinlemeyeBasla()

            }

            let StepperDinleT = UIAlertAction(
                title: "Stepper Dinleyiciyi Aç",
                style: .default
            ) { _ in

                StepperDinleyici.DinlemeyeBasla()

            }

            alert.addAction(ButonDinleT)
            alert.addAction(SliderDinleT)
            alert.addAction(SwitchDinleT)
            alert.addAction(TextFieldDinleT)
            alert.addAction(SegmentedDinleT)
            alert.addAction(StepperDinleT)
            
            topController.present(
                alert,
                animated: true,
                completion: nil
            )

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
            
            let ModsuzT = UIAlertAction(title: "Modsuz Giriş Yap", style: .default) { _ in
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

    @available(iOS 13.0, *)
    @discardableResult
    public static func SaniyeliUyari(baslik: String, mesaj: String, saniye: TimeInterval) -> GuiAlert {
        DispatchQueue.main.async {
            
            dismiss()
            
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else { return }
            
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .alert + 1
            window.isHidden = false
            
            let viewController = UIViewController()
            // Arka planı karartır ve arkadaki uygulamanın dokunulmasını tamamen engeller
            viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            
            let alertBox = UIView()
            alertBox.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
            alertBox.layer.cornerRadius = 14
            alertBox.layer.shadowColor = UIColor.black.cgColor
            alertBox.layer.shadowOpacity = 0.2
            alertBox.layer.shadowOffset = CGSize(width: 0, height: 4)
            alertBox.layer.shadowRadius = 10
            alertBox.translatesAutoresizingMaskIntoConstraints = false
            
            let titleLabel = UILabel()
            titleLabel.text = baslik
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
            titleLabel.textColor = .label
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let messageLabel = UILabel()
            messageLabel.text = mesaj
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
            messageLabel.textColor = .secondaryLabel
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            alertBox.addSubview(titleLabel)
            alertBox.addSubview(messageLabel)
            viewController.view.addSubview(alertBox)
            window.rootViewController = viewController
            
            NSLayoutConstraint.activate([
                alertBox.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                alertBox.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
                alertBox.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
                alertBox.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
                
                titleLabel.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -20),
                
                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                messageLabel.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -20),
                messageLabel.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -20)
            ])
            
            activeWindow = window
            
            if saniye > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + saniye) {
                    dismiss()
                }
            }
        }
        return GuiAlert()
    }
    
    private static func dismiss() {
        activeWindow?.isHidden = true
        activeWindow = nil
    }
}
