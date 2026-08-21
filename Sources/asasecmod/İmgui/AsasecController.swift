import UIKit

final class MainMenuViewController: UIViewController {

    private let freePurchaseSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainUI()
    }

    private func setupMainUI() {
        view.backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // 1. Bedava Satın Alma (Aç/Kapa)
        let freePurchaseRow = createRow(title: "Bedava Satın Alma", control: freePurchaseSwitch)
        stackView.addArrangedSubview(freePurchaseRow)
        
        // Kayıtlı Bedava Satın Alma tercihini yükle
        freePurchaseSwitch.isOn = UserDefaults.standard.bool(forKey: "Preferences_FreePurchase")
        freePurchaseSwitch.addTarget(self, action: #selector(freePurchaseChanged(_:)), for: .valueChanged)

        // 2. Özel Yapılandırma Butonu
        let customConfigButton = createMenuButton(title: "Özel Yapılandırma", action: #selector(openCustomConfig))
        stackView.addArrangedSubview(customConfigButton)

        // 3. Ayarlar Butonu
        let settingsButton = createMenuButton(title: "Ayarlar", action: #selector(openSettings))
        stackView.addArrangedSubview(settingsButton)

        // 4. Mod Hakkında Bilgi Butonu
        let aboutButton = createMenuButton(title: "Mod Hakkında Bilgi", action: #selector(openAbout))
        stackView.addArrangedSubview(aboutButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func createRow(title: String, control: UIView) -> UIView {
        let row = UIView()
        row.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(label)
        row.addSubview(control)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            control.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -10),
            control.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        
        return row
    }

    private func createMenuButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func freePurchaseChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "Preferences_FreePurchase")
    }

    @objc private func openCustomConfig() {
        // Sola kaymayı önlemek için crossDissolve geçiş efekti kullanıyoruz
        let configVC = CustomConfigViewController() // Kendi özel yapılandırma sınıf adınız
        configVC.modalPresentationStyle = .overCurrentContext
        configVC.modalTransitionStyle = .crossDissolve
        present(configVC, animated: true, completion: nil)
    }

    @objc private func openSettings() {
        // Sola kaymayı önleyerek aynı konumda yumuşak geçişle açılır
        let settingsVC = AsasecSettingsViewController()
        settingsVC.modalPresentationStyle = .overCurrentContext
        settingsVC.modalTransitionStyle = .crossDissolve
        present(settingsVC, animated: true, completion: nil)
    }

    @objc private func openAbout() {
        // Mod hakkında bilgi ekranı
    }
}
