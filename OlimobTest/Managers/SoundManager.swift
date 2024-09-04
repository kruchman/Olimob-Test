//
//  SoundManager.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 3/9/24.
//

import AVFoundation

final class SoundManager {
    
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    
    private init() {}
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "noisySound", withExtension: "mp3") else {
            print("Could not find the sound file.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound(withFadeDuration duration: TimeInterval = 2.0) {
        guard let player = player else { return }
        DispatchQueue.global().async {
            let fadeSteps = 20
            let stepDuration = duration / TimeInterval(fadeSteps)
            for i in 0..<fadeSteps {
                DispatchQueue.main.async {
                    player.volume = 1.0 - Float(i) / Float(fadeSteps)
                }
                Thread.sleep(forTimeInterval: stepDuration)
            }
            DispatchQueue.main.async {
                player.stop()
                player.volume = 1.0 // Reset volume for the next playback
            }
        }
    }
}

