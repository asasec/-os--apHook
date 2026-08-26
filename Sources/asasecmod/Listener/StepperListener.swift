import UIKit
import ObjectiveC

public final class StepperDinleyici {

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
        let originalSelector = #selector(UIStepper.setValue(_:))
        let hookedSelector = #selector(UIStepper.asasec_setValue(_:))

        guard
            let originalMethod = class_getInstanceMethod(UIStepper.self, originalSelector),
            let hookedMethod = class_getInstanceMethod(UIStepper.self, hookedSelector)
        else {
            return
        }

        method_exchangeImplementations(originalMethod, hookedMethod)
    }
}

extension UIStepper {

    @objc func asasec_setValue(_ value: Double) {

        let message = """
        Stepper
        Sınıf: \(String(describing: type(of: self)))
        Değer: \(value)
        Minimum: \(minimumValue)
        Maximum: \(maximumValue)
        Adım: \(stepValue)
        Tag: \(tag)
        ID: \(accessibilityIdentifier ?? "Yok")
        """

        let show = {
            GuiAlert.BilgiAktar(
                baslik: "Stepper Yakalandı",
                mesaj: message
            )
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async(execute: show)
        }

        self.asasec_setValue(value)
    }
}
