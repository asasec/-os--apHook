import UIKit
import ObjectiveC

public final class SegmentedDinleyici {

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
        let originalSelector = #selector(UISegmentedControl.setSelectedSegmentIndex(_:))
        let hookedSelector = #selector(UISegmentedControl.asasec_setSelectedSegmentIndex(_:))

        guard
            let originalMethod = class_getInstanceMethod(UISegmentedControl.self, originalSelector),
            let hookedMethod = class_getInstanceMethod(UISegmentedControl.self, hookedSelector)
        else {
            return
        }

        method_exchangeImplementations(originalMethod, hookedMethod)
    }
}

extension UISegmentedControl {

    @objc func asasec_setSelectedSegmentIndex(_ index: Int) {

        let title = index >= 0 && index < numberOfSegments
            ? titleForSegment(at: index) ?? "Başlıksız"
            : "Seçim Yok"

        let message = """
        SegmentedControl
        Sınıf: \(String(describing: type(of: self)))
        Index: \(index)
        Başlık: \(title)
        Segment Sayısı: \(numberOfSegments)
        Tag: \(tag)
        ID: \(accessibilityIdentifier ?? "Yok")
        """

        let show = {
            GuiAlert.BilgiAktar(
                baslik: "Segment Yakalandı",
                mesaj: message
            )
        }

        if Thread.isMainThread {
            show()
        } else {
            DispatchQueue.main.async(execute: show)
        }

        self.asasec_setSelectedSegmentIndex(index)
    }
}
