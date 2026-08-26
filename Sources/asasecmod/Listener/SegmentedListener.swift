import UIKit
import ObjectiveC

public final class SegmentedDinleyici {

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
        let hookedSelector = #selector(UIControl.asasec_segmentedSendAction(_:to:for:))

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

    @objc func asasec_segmentedSendAction(
        _ action: Selector,
        to target: Any?,
        for event: UIEvent?
    ) {
        guard let segmented = self as? UISegmentedControl else {
            self.asasec_segmentedSendAction(
                action,
                to: target,
                for: event
            )
            return
        }

        let index = segmented.selectedSegmentIndex

        let title: String

        if index >= 0 && index < segmented.numberOfSegments {
            title = segmented.titleForSegment(at: index) ?? "Başlıksız"
        } else {
            title = "Seçim Yok"
        }

        let targetClass: String

        if let target = target {
            targetClass = String(describing: type(of: target))
        } else {
            targetClass = "nil"
        }

        let message = """
        Segment
        Sınıf: \(String(describing: type(of: segmented)))
        Index: \(index)
        Başlık: \(title)
        Segment Sayısı: \(segmented.numberOfSegments)
        Target: \(targetClass)
        Metod: \(NSStringFromSelector(action))
        Tag: \(segmented.tag)
        ID: \(segmented.accessibilityIdentifier ?? "Yok")
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

        self.asasec_segmentedSendAction(
            action,
            to: target,
            for: event
        )
    }
}
