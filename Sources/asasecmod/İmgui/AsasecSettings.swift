import UIKit


struct HideMenuHelper {
    static func showHideOptions(onTemporary: @escaping () -> Void, onPermanent: @escaping () -> Void, onCancel: @escaping () -> Void) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            var topController = rootVC
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            let alert = UIAlertController(
                title: "Modu Gizle",
                message: "Mod menüsünü nasıl gizlemek istersiniz?\n\n• Geçici: Oyun kapanıp açılana kadar gizlenir.\n• Kalıcı: Siz tekrar aktif edene kadar gizli kalır.",
                preferredStyle: .alert
            )
            
            let tempAction = UIAlertAction(title: "Geçici Gizle", style: .default) { _ in
                onTemporary()
            }
            
            let permAction = UIAlertAction(title: "Kalıcı Gizle", style: .destructive) { _ in
                onPermanent()
            }
            
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { _ in
                onCancel()
            }
            
            alert.addAction(tempAction)
            alert.addAction(permAction)
            alert.addAction(cancelAction)
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Asasec Settings View
class AsasecSettingsView: UIView {
    var onBackTapped: (() -> Void)?
    var onHideMenuRequested: (() -> Void)?
    var onSaveRequested: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 0.97)
        self.layer.cornerRadius = 16.0
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(red: 0.30, green: 0.60, blue: 1.00, alpha: 1.0).cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10.0
        self.clipsToBounds = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let titleBar = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 40))
        titleBar.backgroundColor = UIColor(red: 0.14, green: 0.17, blue: 0.22, alpha: 1.0)
        
        let maskPath = UIBezierPath(roundedRect: titleBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16.0, height: 16.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        titleBar.layer.mask = maskLayer
        addSubview(titleBar)
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 40))
        titleLabel.text = "⚙️ Mod Ayarları"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleBar.addSubview(titleLabel)
        
        // 1. Seçenekleri Kaydet Butonu
        let saveButton = UIButton(type: .system)
        saveButton.frame = CGRect(x: 18, y: 52, width: 234, height: 36)
        saveButton.backgroundColor = UIColor(red: 0.20, green: 0.50, blue: 0.80, alpha: 1.0)
        saveButton.setTitle("Seçenekleri Kaydet", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        saveButton.layer.cornerRadius = 6.0
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        addSubview(saveButton)
        
        // 2. Modu Gizle Butonu
        let hideMenuButton = UIButton(type: .system)
        hideMenuButton.frame = CGRect(x: 18, y: 98, width: 234, height: 36)
        hideMenuButton.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
        hideMenuButton.setTitle("🙈 Modu Gizle", for: .normal)
        hideMenuButton.setTitleColor(.white, for: .normal)
        hideMenuButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        hideMenuButton.layer.cornerRadius = 6.0
        hideMenuButton.addTarget(self, action: #selector(hideMenuTapped), for: .touchUpInside)
        addSubview(hideMenuButton)
        
        // 3. Geri Dön Butonu
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 18, y: 144, width: 234, height: 36)
        backButton.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.25, alpha: 1.0)
        backButton.setTitle("Geri Dön", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        backButton.layer.cornerRadius = 6.0
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        addSubview(backButton)
    }
    
    @objc private func saveTapped() {
        onSaveRequested?()
    }
    
    @objc private func hideMenuTapped() {
        onHideMenuRequested?()
    }
    
    @objc private func backTapped() {
        onBackTapped?()
    }
}
