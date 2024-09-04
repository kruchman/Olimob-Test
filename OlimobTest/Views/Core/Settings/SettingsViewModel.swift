//
//  SettingsViewModel.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 2/9/24.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @Published var isHapticsOn: Bool = HapticsManager.shared.isHapticsEnabled
    @Published var selectedTab: Tab = .audio
    @Published var tabSelectionViewShouldAppear: Bool = false
    @Published var rateUsViewShouldAppear: Bool = false 
    @ObservedObject var tabManager = TabManager.shared
    
    let audioRecorder: AudioRecorder
    
    init(audioRecorder: AudioRecorder) {
        self.audioRecorder = audioRecorder
    }
    
    func deleteAllrecords() {
        audioRecorder.coreDataManager.removeAll()
    }
}
