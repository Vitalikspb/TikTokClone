//
//  Notifications.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 28.07.2021.
//

import Foundation

struct Notification {
    let text: String
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap {
            Notification(text: "Mocke data \($0)", date: Date())
        }
    }
}
