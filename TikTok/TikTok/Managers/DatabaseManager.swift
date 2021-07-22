//
//  DatabaseManager.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    // Public
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
