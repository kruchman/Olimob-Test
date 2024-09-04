//
//  CleanerViewModel.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import Foundation

@MainActor
final class CleanerViewModel: ObservableObject {
    
    @Published var isButtonTapped: Bool = false
    @Published var progressBarValue: Float = 0.0
    @Published var timer: Timer?
    @Published var hapticTimer: Timer?
    @Published var buttonActivityTime: Int = 0
    
    func buttonTapped() {
        SoundManager.shared.playSound()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.buttonActivityTime += 1
                self.progressBarValue = min(self.progressBarValue + 0.1, 1.0)
                if self.buttonActivityTime == 10 {
                    SoundManager.shared.stopSound(withFadeDuration: 1.0)
                }
                if self.buttonActivityTime > 10 {
                    self.stopTheTimer()
                }
            }
        }
    }
    
    func stopTheTimer() {
        SoundManager.shared.stopSound(withFadeDuration: 1.0)
        isButtonTapped = false
        buttonActivityTime = 0
        progressBarValue = 0.0
        timer?.invalidate()
        timer = nil
    }
    
    func startHapticFeedback() {
            hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                HapticsManager.shared.triggerHapticFeedback(hapticsPower: .heavy)
            }
        }
        
        func stopHapticFeedback() {
            hapticTimer?.invalidate()
            hapticTimer = nil
        }
}
