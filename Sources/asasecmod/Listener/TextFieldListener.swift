import UIKit
import ObjectiveC

public final class TextFieldDinleyici {

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
        let originalSelector = #selector(UITextField.insertText(_:))
        let hookedSelector = #selector(UITextField.asasec_insertText(_:))

        guard
            let originalMethod = class_getInstanceMethod(UITextField.self, originalSelector),
            let hookedMethod = class_getInstanceMethod(UITextField.self, hookedSelector)
        else {
            return
        }

        method_exchangeImplementations(originalMethod, hookedMethod)
    }
}

extension UITextField {

    @objc func asasec_insertText(_ text: String) {

        let message = """
        TextField
        Sınıf: \(String(describing: type(of: self)))
        Girilen: \(text)
        Mevcut Metin: \(self.text ?? "")
        Placeholder: \(placeholder ?? "Yok")
        Tag: \(tag)
        ID: \(accessibilityIdentifier ?? "Yok")
        """

        let show = {
            GuiAlert.BilgiAktar(
                baslik: "TextField Yakalandı",
                mesaj: message
            )
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async(execute: show)
        }

        self.asasec_insertText(text)
    }
}
