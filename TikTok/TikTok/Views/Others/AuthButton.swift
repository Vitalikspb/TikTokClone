//
//  AuthButton.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 26.07.2021.
//

import UIKit

class AuthButton: UIButton {

    let type: ButtonType
    
    enum ButtonType {
        case signIn
        case signOut
        case plain
        
        var title: String {
            switch self {
            case .signIn:
                return "Sign In"
            case .signOut:
                return "Sign Out"
            case .plain:
                return "-"
            }
        }
    }
    
    init(type: ButtonType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        if type != .plain {
            setTitle(type.title, for: .normal)
        }
        
        setTitleColor(.white, for: .normal)
        
        switch type {
        case .signIn: backgroundColor = .systemBlue
        case .signOut: backgroundColor = .systemGreen
        case .plain:
            setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    

}
