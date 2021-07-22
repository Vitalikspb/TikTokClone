//
//  HapticsManager.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import Foundation
import UIKit

final class HapticManager {
    
    static let shared = HapticManager()
    
    private init() {}
    
    // Public
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
