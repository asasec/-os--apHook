import UIKit

struct AlertHelper {
    static func show(title: String, message: String) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            var topController = rootVC
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

public class AsasecController: UIViewController {
    public static let shared = AsasecController()
    
    private var nativeMenu: UIView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        let screenBounds = UIScreen.main.bounds
        let menuView = NativeMenuViewWrapper(frame: screenBounds)
        self.view.addSubview(menuView)
        self.nativeMenu = menuView
    }
}

class NativeMenuViewWrapper: UIView {
    private var mobileMenuWindow: UIView!
    private var floatingIcon: UIButton!
    private var customConfigView: CustomConfigView?
    private var settingsView: AsasecSettingsView?
    
    private var freePurchaseButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        mobileMenuWindow = UIView(frame: CGRect(x: 50, y: 80, width: 270, height: 230))
        mobileMenuWindow.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 0.97)
        mobileMenuWindow.layer.cornerRadius = 16.0
        mobileMenuWindow.layer.borderWidth = 1.5
        mobileMenuWindow.layer.borderColor = UIColor(red: 0.30, green: 0.60, blue: 1.00, alpha: 1.0).cgColor
        mobileMenuWindow.layer.shadowColor = UIColor.black.cgColor
        mobileMenuWindow.layer.shadowOffset = CGSize(width: 0, height: 8)
        mobileMenuWindow.layer.shadowOpacity = 0.5
        mobileMenuWindow.layer.shadowRadius = 10.0
        mobileMenuWindow.clipsToBounds = false
        
        mobileMenuWindow.isHidden = true
        addSubview(mobileMenuWindow)
        
        let menuPan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        mobileMenuWindow.addGestureRecognizer(menuPan)
        
        let titleBar = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 40))
        titleBar.backgroundColor = UIColor(red: 0.14, green: 0.17, blue: 0.22, alpha: 1.0)
        
        let maskPath = UIBezierPath(roundedRect: titleBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16.0, height: 16.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        titleBar.layer.mask = maskLayer
        mobileMenuWindow.addSubview(titleBar)
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 40))
        titleLabel.text = "⭐ @asasec Mod Menü"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleBar.addSubview(titleLabel)
        
        let closeBtn = UIButton(type: .system)
        closeBtn.frame = CGRect(x: 230, y: 8, width: 24, height: 24)
        closeBtn.setTitle("✕", for: .normal)
        closeBtn.setTitleColor(UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1.0), for: .normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        closeBtn.addTarget(self, action: #selector(minimizeMenu), for: .touchUpInside)
        titleBar.addSubview(closeBtn)
        
        // 1. Bedava Satın Alma Butonu
        freePurchaseButton = createButton(frame: CGRect(x: 18, y: 48, width: 234, height: 32), title: "", color: .red)
        updateFreePurchaseUI()
        freePurchaseButton.addTarget(self, action: #selector(freePurchaseTapped), for: .touchUpInside)
        mobileMenuWindow.addSubview(freePurchaseButton)
        
        // 2. Özel Yapılandırma Tuşu
        let customConfigBtn = createButton(frame: CGRect(x: 18, y: 86, width: 234, height: 32), title: "Özel Yapılandırma", color: UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 1.0))
        customConfigBtn.addTarget(self, action: #selector(customConfigTapped), for: .touchUpInside)
        mobileMenuWindow.addSubview(customConfigBtn)
        
        // 3. Ayarlar Tuşu
        let settingsBtn = createButton(frame: CGRect(x: 18, y: 124, width: 234, height: 32), title: "⚙️ Ayarlar", color: UIColor(red: 0.30, green: 0.50, blue: 0.30, alpha: 1.0))
        settingsBtn.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        mobileMenuWindow.addSubview(settingsBtn)
        
        // 4. Mod Hakkında Bilgi Butonu
        let bilgiverbize = createButton(frame: CGRect(x: 18, y: 162, width: 234, height: 32), title: "💡 Mod Hakkında & Bilgi", color: UIColor(red: 0.50, green: 0.20, blue: 0.60, alpha: 1.0))
        bilgiverbize.addTarget(self, action: #selector(bilgiverbizeTapped), for: .touchUpInside)
        mobileMenuWindow.addSubview(bilgiverbize)

        // Yüzen Simge
        floatingIcon = UIButton(type: .system)
        floatingIcon.frame = CGRect(x: 50, y: 80, width: 54, height: 54)
        floatingIcon.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.13, alpha: 0.92)
        floatingIcon.setTitle("📦", for: .normal)
        floatingIcon.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        floatingIcon.layer.cornerRadius = 27.0
        floatingIcon.layer.borderWidth = 2.0
        floatingIcon.layer.borderColor = UIColor(red: 0.30, green: 0.60, blue: 1.00, alpha: 1.0).cgColor
        floatingIcon.layer.shadowColor = UIColor.black.cgColor
        floatingIcon.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingIcon.layer.shadowOpacity = 0.6
        floatingIcon.layer.shadowRadius = 8.0
        floatingIcon.isHidden = false
        floatingIcon.addTarget(self, action: #selector(restoreMenu), for: .touchUpInside)
        addSubview(floatingIcon)
        
        let iconPan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        floatingIcon.addGestureRecognizer(iconPan)
    }
    
    private func createButton(frame: CGRect, title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.frame = frame
        btn.backgroundColor = color
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.layer.cornerRadius = 6.0
        return btn
    }
    
    private func updateFreePurchaseUI() {
        if Preferences.isFreePurchaseEnabled {
            freePurchaseButton.setTitle("Bedava Satın Alma: Açık", for: .normal)
            freePurchaseButton.backgroundColor = UIColor.systemGreen
        } else {
            freePurchaseButton.setTitle("Bedava Satın Alma: Kapalı", for: .normal)
            freePurchaseButton.backgroundColor = UIColor.systemRed
        }
        freePurchaseButton.setTitleColor(.white, for: .normal)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self { return nil }
        return hitView
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: self)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: self)
    }
    
    @objc private func minimizeMenu() {
        mobileMenuWindow.isHidden = true
        floatingIcon.center = mobileMenuWindow.center
        floatingIcon.isHidden = false
    }
    
    @objc private func restoreMenu() {
        floatingIcon.isHidden = true
        mobileMenuWindow.center = floatingIcon.center
        mobileMenuWindow.isHidden = false
    }
    
    @objc private func freePurchaseTapped() {
        Preferences.isFreePurchaseEnabled.toggle()
        updateFreePurchaseUI()
    }
    
    @objc private func customConfigTapped() {
        let currentCenter = mobileMenuWindow.center
        mobileMenuWindow.isHidden = true
        
        let configView = CustomConfigView(frame: CGRect(x: 0, y: 0, width: 270, height: 230))
        configView.center = currentCenter
        
        configView.onBackTapped = { [weak self, weak configView] in
            configView?.removeFromSuperview()
            self?.customConfigView = nil
            self?.mobileMenuWindow.center = configView?.center ?? self?.mobileMenuWindow.center ?? .zero
            self?.mobileMenuWindow.isHidden = false
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        configView.addGestureRecognizer(pan)
        
        addSubview(configView)
        self.customConfigView = configView
    }
    
    @objc private func settingsTapped() {
        let currentCenter = mobileMenuWindow.center
        mobileMenuWindow.isHidden = true
        
        let sView = AsasecSettingsView(frame: CGRect(x: 0, y: 0, width: 270, height: 190))
        sView.center = currentCenter
        
        // 1. Geri Dön
        sView.onBackTapped = { [weak self, weak sView] in
            sView?.removeFromSuperview()
            self?.settingsView = nil
            self?.mobileMenuWindow.center = sView?.center ?? self?.mobileMenuWindow.center ?? .zero
            self?.mobileMenuWindow.isHidden = false
        }
        
        // 2. Seçenekleri Kaydet Butonu (Uyarı olmaması için [weak self] kaldırıldı, doğrudan statik değerler kaydediliyor)
        sView.onSaveRequested = {
            UserDefaults.standard.set(Preferences.isFreePurchaseEnabled, forKey: "Preferences_FreePurchase")
            UserDefaults.standard.set(Preferences.isZeroPointOnePriceEnabled, forKey: "Preferences_ZeroPointOne")
            UserDefaults.standard.synchronize()
            
            AlertHelper.show(title: "⚙️ Ayarlar", message: "Seçenekler başarıyla kaydedildi!")
        }
        
        // 3. Modu Gizle
        sView.onHideMenuRequested = { [weak self, weak sView] in
            sView?.removeFromSuperview()
            self?.settingsView = nil
            self?.mobileMenuWindow.isHidden = true
            self?.floatingIcon.isHidden = true
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sView.addGestureRecognizer(pan)
        
        addSubview(sView)
        self.settingsView = sView
    }
    
    @objc private func bilgiverbizeTapped() { 
        AlertHelper.show(title: "BOMBOM", message: "Senin için bebeğim bu mod 👄")
    }
}
