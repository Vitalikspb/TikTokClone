//
//  PostComments.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import Foundation

struct PostComments {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComments] {
        let user = User(username: "2 Pac", profilePictureURL: nil, identifier: UUID().uuidString)
        
        let comments = [PostComments(text: "This is 2 Pac says", user: user, date: Date()),
                        PostComments(text: "This is second comments", user: user, date: Date())
        ]
        return comments
    }
}
