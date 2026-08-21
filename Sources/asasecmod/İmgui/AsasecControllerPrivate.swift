import UIKit

class CustomConfigView: UIView {
    private var customWindow: UIView!
    private var isFeatureEnabled: Bool = false
    private var toggleButton: UIButton!
    var onBackTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        customWindow = UIView(frame: CGRect(x: 50, y: 80, width: 270, height: 180))
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
        titleLabel.text = "⚙️ Özel Yapılandırma"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleBar.addSubview(titleLabel)
        
        // Fiyatı 0.01 Yap Butonu (Başlangıç durumunu Preferences'tan alıyoruz)
        isFeatureEnabled = Preferences.isZeroPointOnePriceEnabled
        
        toggleButton = UIButton(type: .system)
        toggleButton.frame = CGRect(x: 18, y: 56, width: 234, height: 36)
        
        // Yazı rengi her iki durumda da net okunması için beyaz yapıldı
        toggleButton.setTitleColor(.white, for: .normal)
        
        updateToggleButtonUI()
        toggleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        toggleButton.layer.cornerRadius = 6.0
        toggleButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
        customWindow.addSubview(toggleButton)
        
        // Geri Tuşu
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 18, y: 104, width: 234, height: 36)
        backButton.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.25, alpha: 1.0)
        backButton.setTitle("Geri Dön", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        backButton.layer.cornerRadius = 6.0
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        customWindow.addSubview(backButton)
    }
    
    private func updateToggleButtonUI() {
        if isFeatureEnabled {
            toggleButton.setTitle("Fiyatı 0.01 Yap: Açık", for: .normal)
            toggleButton.backgroundColor = UIColor.systemGreen
        } else {
            toggleButton.setTitle("Fiyatı 0.01 Yap: Kapalı", for: .normal)
            toggleButton.backgroundColor = UIColor.systemRed
        }
        // Renk ayarının her değişimde kaybolmaması için garantiye alıyoruz
        toggleButton.setTitleColor(.white, for: .normal)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: self)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: self)
    }
    
    @objc private func toggleTapped() {
        isFeatureEnabled.toggle()
        Preferences.isZeroPointOnePriceEnabled = isFeatureEnabled
        updateToggleButtonUI()
        
        let statusText = isFeatureEnabled ? "Açık" : "Kapalı"
        AlertHelper.show(title: "Özel Yapılandırma", message: "Fiyatı 0.01 Yap: \(statusText)")
    }
    
    @objc private func backTapped() {
        onBackTapped?()
    }
}
