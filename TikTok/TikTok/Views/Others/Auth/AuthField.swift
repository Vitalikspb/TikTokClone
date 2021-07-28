//
//  AuthField.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 26.07.2021.
//

import UIKit

class AuthField: UITextField {
    
    private let type: FieldType
    
    enum FieldType {
        case username
        case email
        case password
        
        var title: String {
            switch self {
            case .username:
                return "Username"
            case .email:
                return "Email address"
            case .password:
                return "Password"
            }
        }
    }

    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
        
        if type == .password {
            textContentType = .oneTimeCode
            isSecureTextEntry = true
        } else {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        }
    }
    
    

}
