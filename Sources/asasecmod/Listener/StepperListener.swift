import UIKit
import ObjectiveC

public final class StepperDinleyici {

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
        swizzle()
    }

    private static func swizzle() {
        let originalSelector = #selector(UIControl.sendAction(_:to:for:))
        let hookedSelector = #selector(UIControl.asasec_stepperSendAction(_:to:for:))

        guard
            let originalMethod = class_getInstanceMethod(
                UIControl.self,
                originalSelector
            ),
            let hookedMethod = class_getInstanceMethod(
                UIControl.self,
                hookedSelector
            )
        else {
            return
        }

        method_exchangeImplementations(
            originalMethod,
            hookedMethod
        )
    }
}

extension UIControl {

    @objc func asasec_stepperSendAction(
        _ action: Selector,
        to target: Any?,
        for event: UIEvent?
    ) {
        guard let stepper = self as? UIStepper else {
            self.asasec_stepperSendAction(
                action,
                to: target,
                for: event
            )
            return
        }

        let targetClass: String

        if let target = target {
            targetClass = String(describing: type(of: target))
        } else {
            targetClass = "nil"
        }

        let message = """
        Stepper
        Sınıf: \(String(describing: type(of: stepper)))
        Değer: \(stepper.value)
        Minimum: \(stepper.minimumValue)
        Maximum: \(stepper.maximumValue)
        Adım: \(stepper.stepValue)
        Target: \(targetClass)
        Metod: \(NSStringFromSelector(action))
        Tag: \(stepper.tag)
        ID: \(stepper.accessibilityIdentifier ?? "Yok")
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

        self.asasec_stepperSendAction(
            action,
            to: target,
            for: event
        )
    }
}
