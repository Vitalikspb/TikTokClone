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
    
    private let storageBucket = Storage.storage().reference()
    
    private init() {}
    
    // Public
    
    public func uploadVideo(from url: URL, filename: String, completion: @escaping(Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        storageBucket.child("video/\(username)/\(filename)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    
    public func uploadProfilePicture(with image: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        guard let imageData = image.pngData() else { return }
        
        let path = "profile_picture/\(username)/picture.png"
        
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }
    
    public func generateVideoName() -> String {
        
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }
    
    func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
    
}
