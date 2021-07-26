//
//  SignInViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    public var completion: (() -> Void)?
    
    private let usernameField = AuthField(type: .username)
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    
    private let signUpButton = AuthButton(type: .signUp, title: nil)
    private let termsButton = AuthButton(type: .plain, title: "Terms of service")
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Create account"
        
        addSubviews()
        configureFields()
        configureButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize) / 2,
                                     y: view.safeAreaInsets.top + 5,
                                     width: imageSize,
                                     height: imageSize)
        usernameField.frame = CGRect(x: 20,
                                     y: logoImageView.bottom + 20,
                                     width: view.width - 40,
                                     height: 55)
        emailField.frame = CGRect(x: 20,
                                  y: usernameField.bottom + 15,
                                  width: view.width - 40,
                                  height: 55)
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.bottom + 15,
                                     width: view.width - 40,
                                     height: 55)
        
        signUpButton.frame = CGRect(x: 20,
                                    y: passwordField.bottom + 20,
                                    width: view.width - 40,
                                    height: 55)
        termsButton.frame = CGRect(x: 20,
                                      y: signUpButton.bottom + 40,
                                      width: view.width - 40,
                                      height: 55)
    }
    
    // MARK: - Helpers Function
    
    func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        usernameField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
    }
    
    func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
    }
    
    func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    
    
    @objc func didTapSignUp() {
        didTapKeyboardDone()
        
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              !username.contains("."),
              !username.contains(" ") else {
            
            let alert = UIAlertController(title: "Woops", message: "Please make sure to enter a valid username, email and password. Your password must be atleast 6 characted long", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        AuthManager.shared.signUp(with: username, emailAddress: email, password: password) { success in
            if success {
                
            }
        }
    }
    
    @objc func didTapTerms() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/terms") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
}
