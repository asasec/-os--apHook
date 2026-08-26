import UIKit
import ObjectiveC

public final class ControlDinleyici {

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
        let originalSelector = #selector(UIControl.sendAction(_:to:for:))
        let hookedSelector = #selector(UIControl.asasec_controlSendAction(_:to:for:))

        guard
            let originalMethod = class_getInstanceMethod(UIControl.self, originalSelector),
            let hookedMethod = class_getInstanceMethod(UIControl.self, hookedSelector)
        else {
            return
        }

        method_exchangeImplementations(originalMethod, hookedMethod)
    }
}

extension UIControl {

    @objc func asasec_controlSendAction(
        _ action: Selector,
        to target: Any?,
        for event: UIEvent?
    ) {

        let controlClass = String(describing: type(of: self))

        let targetClass: String

        if let target = target {
            targetClass = String(describing: type(of: target))
        } else {
            targetClass = "nil"
        }

        let methodName = NSStringFromSelector(action)

        let message = """
        UIControl
        Sınıf: \(controlClass)
        Target: \(targetClass)
        Metod: \(methodName)
        Tag: \(tag)
        ID: \(accessibilityIdentifier ?? "Yok")
        """

        let show = {
            GuiAlert.BilgiAktar(
                baslik: "UIControl Yakalandı",
                mesaj: message
            )
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async(execute: show)
        }

        self.asasec_controlSendAction(
            action,
            to: target,
            for: event
        )
    }
}
