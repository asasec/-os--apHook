import UIKit

final class AsasecSettingsViewController: UIViewController {

    private let hideMenuSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPreferences()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
        title = "Mod Ayarları"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Modu Gizle Satırı
        let hideRow = UIView()
        let hideLabel = UILabel()
        hideLabel.text = "Modu Gizle"
        hideLabel.textColor = .white
        hideLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        hideLabel.translatesAutoresizingMaskIntoConstraints = false
        hideMenuSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        hideRow.addSubview(hideLabel)
        hideRow.addSubview(hideMenuSwitch)
        
        NSLayoutConstraint.activate([
            hideLabel.leadingAnchor.constraint(equalTo: hideRow.leadingAnchor, constant: 16),
            hideLabel.centerYAnchor.constraint(equalTo: hideRow.centerYAnchor),
            hideMenuSwitch.trailingAnchor.constraint(equalTo: hideRow.trailingAnchor, constant: -16),
            hideMenuSwitch.centerYAnchor.constraint(equalTo: hideRow.centerYAnchor),
            hideRow.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        stackView.addArrangedSubview(hideRow)

        // Seçenekleri Kaydet Butonu
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Seçenekleri Kaydet", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(saveButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func loadPreferences() {
        let isHidden = UserDefaults.standard.bool(forKey: "AsasecHideMenuPref")
        hideMenuSwitch.isOn = isHidden
    }

    @objc private func saveTapped() {
        UserDefaults.standard.set(hideMenuSwitch.isOn, forKey: "AsasecHideMenuPref")
        UserDefaults.standard.synchronize()
        
        let alert = UIAlertController(title: "Başarılı", message: "Ayarlar kaydedildi! Oyundan çıkıp girseniz bile geçerli olacaktır.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
