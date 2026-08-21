import UIKit

class AsasecSettingsView: UIView {
    var onBackTapped: (() -> Void)?
    var onHideMenuRequested: (() -> Void)?
    
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
        
        // 1. Modu Gizle Butonu (Tüm arayüzü tamamen gizler)
        let hideMenuButton = UIButton(type: .system)
        hideMenuButton.frame = CGRect(x: 18, y: 56, width: 234, height: 40)
        hideMenuButton.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0.30, alpha: 1.0)
        hideMenuButton.setTitle("🙈 Modu Gizle", for: .normal)
        hideMenuButton.setTitleColor(.white, for: .normal)
        hideMenuButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        hideMenuButton.layer.cornerRadius = 6.0
        hideMenuButton.addTarget(self, action: #selector(hideMenuTapped), for: .touchUpInside)
        addSubview(hideMenuButton)
        
        // 2. Geri Dön Butonu
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 18, y: 110, width: 234, height: 40)
        backButton.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.25, alpha: 1.0)
        backButton.setTitle("Geri Dön", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        backButton.layer.cornerRadius = 6.0
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        addSubview(backButton)
    }
    
    @objc private func hideMenuTapped() {
        // Tamamen gizleme sinyalini gönder
        onHideMenuRequested?()
    }
    
    @objc private func backTapped() {
        onBackTapped?()
    }
}
