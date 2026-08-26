import UIKit
import ObjectiveC

public final class SwitchDinleyici {

    private static var isStarted = false
    private static let lock = NSLock()

    public static func DinlemeyeBasla() {
        lock.lock()
        defer { lock.unlock() }

        guard !isStarted else { return }

        isStarted = true
        swizzle()
    }

    private static func swizzle() {
        let originalSelector = #selector(UISwitch.setOn(_:animated:))
        let hookedSelector = #selector(UISwitch.asasec_setOn(_:animated:))

        guard
            let originalMethod = class_getInstanceMethod(UISwitch.self, originalSelector),
            let hookedMethod = class_getInstanceMethod(UISwitch.self, hookedSelector)
        else {
            return
        }

        method_exchangeImplementations(originalMethod, hookedMethod)
    }
}

extension UISwitch {

    @objc func asasec_setOn(
        _ on: Bool,
        animated: Bool
    ) {
        let message = """
        Switch
        Sınıf: \(String(describing: type(of: self)))
        Durum: \(on ? "Açık" : "Kapalı")
        Tag: \(tag)
        ID: \(accessibilityIdentifier ?? "Yok")
        """

        let show = {
            GuiAlert.BilgiAktar(
                baslik: "Switch Yakalandı",
                mesaj: message
            )
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async(execute: show)
        }

        self.asasec_setOn(on, animated: animated)
    }
}
