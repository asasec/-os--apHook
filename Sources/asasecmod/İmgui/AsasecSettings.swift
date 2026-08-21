import UIKit

class AsasecSettingsView: UIView {
    private var customWindow: UIView!
    private var hideMenuSwitch = UISwitch()
    var onBackTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
        loadPreferences()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        customWindow = UIView(frame: CGRect(x: 50, y: 80, width: 270, height: 210))
        customWindow.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 0.97)
        customWindow.layer.cornerRadius = 16.0
        customWindow.layer.borderWidth = 1.5
        customWindow.layer.borderColor = UIColor(red: 0.30, green: 0.60, blue: 1.00, alpha: 1.0).cgColor
        customWindow.layer.shadowColor = UIColor.black.cgColor
        customWindow.layer.shadowOffset = CGSize(width: 0, height: 8)
        customWindow.layer.shadowOpacity = 0.5
        customWindow.layer.shadowRadius = 10.0
        customWindow.clipsToBounds = false
        addSubview(customWindow)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        customWindow.addGestureRecognizer(pan)
        
        let titleBar = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 40))
        titleBar.backgroundColor = UIColor(red: 0.14, green: 0.17, blue: 0.22, alpha: 1.0)
        
        let maskPath = UIBezierPath(roundedRect: titleBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16.0, height: 16.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        titleBar.layer.mask = maskLayer
        customWindow.addSubview(titleBar)
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 40))
        titleLabel.text = "⚙️ Mod Ayarları"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleBar.addSubview(titleLabel)
        
        // Modu Gizle Etiketi ve Anahtarı
        let hideLabel = UILabel(frame: CGRect(x: 18, y: 56, width: 160, height: 32))
        hideLabel.text = "Modu Gizle:"
        hideLabel.textColor = .white
        hideLabel.font = UIFont.boldSystemFont(ofSize: 13)
        customWindow.addSubview(hideLabel)
        
        hideMenuSwitch.frame = CGRect(x: 200, y: 56, width: 50, height: 32)
        customWindow.addSubview(hideMenuSwitch)
        
        // Seçenekleri Kaydet Butonu
        let saveButton = UIButton(type: .system)
        saveButton.frame = CGRect(x: 18, y: 104, width: 234, height: 36)
        saveButton.backgroundColor = UIColor(red: 0.20, green: 0.50, blue: 0.80, alpha: 1.0)
        saveButton.setTitle("Seçenekleri Kaydet", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        saveButton.layer.cornerRadius = 6.0
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        customWindow.addSubview(saveButton)
        
        // Geri Tuşu
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 18, y: 152, width: 234, height: 36)
        backButton.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.25, alpha: 1.0)
        backButton.setTitle("Geri Dön", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        backButton.layer.cornerRadius = 6.0
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        customWindow.addSubview(backButton)
    }
    
    private func loadPreferences() {
        let isHidden = UserDefaults.standard.bool(forKey: "AsasecHideMenuPref")
        hideMenuSwitch.isOn = isHidden
    }
    
    @objc private func saveTapped() {
        UserDefaults.standard.set(hideMenuSwitch.isOn, forKey: "AsasecHideMenuPref")
        UserDefaults.standard.synchronize()
        AlertHelper.show(title: "Ayarlar", message: "Seçenekler başarıyla kaydedildi!")
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: self)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: self)
    }
    
    @objc private func backTapped() {
        onBackTapped?()
    }
}
