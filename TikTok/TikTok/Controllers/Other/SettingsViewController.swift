//
//  SettingsViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit
import SafariServices





class SettingsViewController: UIViewController {
    
    var sections = [SettingSection]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            SettingSection(
                title: "Preferences",
                options: [
                    SettingsOption(title: "Save Video", handler: { })
                ]
            ),
            SettingSection(
                title: "Information",
                options: [
                    SettingsOption(title: "Terms of service", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service") else { return }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    }),
                    SettingsOption(title: "Privacy policy", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/privacy-policy") else { return }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    })
                ]
            )
        ]
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func createFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        let button = UIButton(frame: CGRect(x: (view.width - 200) / 2, y: 25, width: 200, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }
    
    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign out", message: "Would you like to sign out", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { [weak self] _ in
            DispatchQueue.main.async {
            AuthManager.shared.signOut { success in
                if success {
                    UserDefaults.standard.setValue(nil, forKey: "username")
                    UserDefaults.standard.setValue(nil, forKey: "profile_picture_url")
                    
                    let vc = SignInViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true, completion: nil)
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.tabBarController?.selectedIndex = 0
                } else {
                    // failed
                    let alert = UIAlertController(title: "Woops", message: "Something went wrong when signing out> Please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            }
        }))
        present(actionSheet, animated: true)
    }
    
 

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        if model.title == "Save Video" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: SwitchCellViewModel(title: model.title, isOn: UserDefaults.standard.bool(forKey: "save_video")))
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SettingsViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool) {
        UserDefaults.standard.setValue(isOn, forKey: "Save Video")
    }
    
    
}
