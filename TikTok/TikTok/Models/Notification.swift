//
//  Notification.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 28.07.2021.
//

import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike: return "postLike"
        case .userFollow: return "userFollow"
        case .postComment: return "postComment"
        }
    }
}

class Notification {
    var identifier = UUID().uuidString
    var ishidding = false
    let text: String
    let type: NotificationType
    let date: Date
    
    init(text: String, type: NotificationType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notification] {
        let first = Array(0...5).compactMap {
            Notification(text: "Follows \($0)",
                         type: .userFollow(username: "Follows"),
                         date: Date())
        }
        let second = Array(0...5).compactMap {
            Notification(text: "post Comment \($0)",
                         type: .postComment(postName: "post Comment"),
                         date: Date())
        }
        let third = Array(0...5).compactMap {
            Notification(text: "post like \($0)",
                         type: .postLike(postName: "post like"),
                         date: Date())
        }
        return second + first + third
    }
    
}
