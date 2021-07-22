//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    public static let shared = AuthManager()
    
    private init() {}
    
    // Public
    
    public func signIn(with method: SignInMethod) {
    
    }
    
    public func signOut() {
        
    }
}
