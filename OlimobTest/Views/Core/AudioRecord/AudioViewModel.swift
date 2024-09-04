//
//  AudioViewModel.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AudioViewModel: ObservableObject {
    
    @Published var records: [Record] = []
    @Published var isRecording: Bool = false
    @Published var shouldHintAppear: Bool = false
    @ObservedObject var audioRecorder: AudioRecorder
    
    @Published var currentDb: Int = 0
    private var cancellables = Set<AnyCancellable>()

    init(audioRecorder: AudioRecorder) {
        self._audioRecorder = ObservedObject(wrappedValue: audioRecorder)
    }
    
    func startRecording() {
        audioRecorder.startNewRecording()
        updateCurrentDb()
    }
    
    func stopRecording() {
        audioRecorder.stopMonitoringAndSaveRecording()
    }
    
    func updateCurrentDb() {
        audioRecorder.$currentDb
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentDb in
                self?.currentDb = currentDb
            }
            .store(in: &cancellables)
        
//        audioRecorder.$records
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] records in
//                guard let self = self else { return }
//                if !records.isEmpty && !self.isRecording && records.count == 1 {
//                    withAnimation(.easeInOut(duration: 1.5)) {
//                        self.shouldHintAppear = true
//                    }
//                } else {
//                    self.shouldHintAppear = false
//                }
//            }
//            .store(in: &cancellables)
    }
    
}

