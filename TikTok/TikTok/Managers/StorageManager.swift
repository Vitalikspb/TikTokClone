//
//  StorageManager.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let database = Storage.storage().reference()
    
    private init() {}
    
    // Public
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    public func uploadVideoURL(from url: URL) {
        
    }
}
