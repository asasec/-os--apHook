import UIKit
import ObjectiveC

public final class SliderDinleyici {

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
        let originalSelector = #selector(UISlider.setValue(_:animated:))
        let hookedSelector = #selector(UISlider.asasec_setValue(_:animated:))

        guard
            let originalMethod = class_getInstanceMethod(UISlider.self, originalSelector),
            let hookedMethod = class_getInstanceMethod(UISlider.self, hookedSelector)
        else {
            return
        }

        method_exchangeImplementations(originalMethod, hookedMethod)
    }
}

extension UISlider {

    @objc func asasec_setValue(
        _ value: Float,
        animated: Bool
    ) {
        let message = """
        Slider
        Sınıf: \(String(describing: type(of: self)))
        Değer: \(value)
        Minimum: \(minimumValue)
        Maximum: \(maximumValue)
        Tag: \(tag)
        ID: \(accessibilityIdentifier ?? "Yok")
        """

        let show = {
            GuiAlert.BilgiAktar(
                baslik: "Slider Yakalandı",
                mesaj: message
            )
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async(execute: show)
        }

        self.asasec_setValue(value, animated: animated)
    }
}
