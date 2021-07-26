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
    
    //MARK: - Properties
    
    public static let shared = AuthManager()
    public var isSignIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    //MARK: - init
    
    private init() {}
    
    
    //MARK: - Helpers Function
    
    public func signIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
    
    }
    
    public func signUp(with username: String, emailAddress: String, password: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
}
