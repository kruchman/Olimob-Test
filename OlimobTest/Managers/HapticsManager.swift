//
//  HapticsManager.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 2/9/24.
//

import SwiftUI

final class HapticsManager {
    static let shared = HapticsManager()
    
    private let hapticsEnabledKey = "hapticsEnabled"
    
    var isHapticsEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hapticsEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hapticsEnabledKey)
        }
    }
    
    private init() {}
    
    func triggerHapticFeedback(hapticsPower: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isHapticsEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: hapticsPower)
        generator.prepare()
        generator.impactOccurred()
    }
}

