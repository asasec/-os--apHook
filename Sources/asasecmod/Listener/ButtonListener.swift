import UIKit
import ObjectiveC

public final class ButonDinleyici {

    private static var isStarted = false
    private static let lock = NSLock()

    public static func DinlemeyeBasla() {
        lock.lock()
        defer {
            lock.unlock()
        }

        guard !isStarted else {
            return
        }

        isStarted = true
        swizzleSendAction()
    }

    private static func swizzleSendAction() {
        let originalSelector = #selector(UIControl.sendAction(_:to:for:))
        let hookedSelector = #selector(UIControl.asasec_sendAction(_:to:for:))

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

    @objc func asasec_sendAction(
        _ action: Selector,
        to target: Any?,
        for event: UIEvent?
    ) {
        guard let button = self as? UIButton else {
            self.asasec_sendAction(
                action,
                to: target,
                for: event
            )
            return
        }

        let buttonTitle: String

        if let title = button.title(for: .normal), !title.isEmpty {
            buttonTitle = title
        } else {
            buttonTitle = "Başlıksız UIButton"
        }

        let controlClass = String(describing: type(of: button))

        let targetClass: String

        if let target = target {
            targetClass = String(describing: type(of: target))
        } else {
            targetClass = "nil"
        }

        let methodName = NSStringFromSelector(action)
        let identifier = button.accessibilityIdentifier ?? "Yok"
        let tag = button.tag

        let mesaj = """
        Buton: \(buttonTitle)
        Sınıf: \(controlClass)
        Target: \(targetClass)
        Metod: \(methodName)
        ID: \(identifier)
        Tag: \(tag)
        """

        if Thread.isMainThread {
            GuiAlert.BilgiAktar(
                baslik: "Tuş Yakalandı",
                mesaj: mesaj
            )
        } else {
            DispatchQueue.main.async {
                GuiAlert.BilgiAktar(
                    baslik: "Tuş Yakalandı",
                    mesaj: mesaj
                )
            }
        }

        self.asasec_sendAction(
            action,
            to: target,
            for: event
        )
    }
}
