//
//  HistoryViewModel.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import SwiftUI
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    
    @Published var records: [Record] = []
    @Published var selectedRecord: Record?
    private var cancellables = Set<AnyCancellable>()
    
    let audioRecorder: AudioRecorder
    
    init(audioRecorder: AudioRecorder) {
        self.audioRecorder = audioRecorder
        updateRecords()
        
    }
    
    func updateRecords() {
        audioRecorder.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                self?.records = records
                if !records.isEmpty {
                    self?.selectedRecord = records.last
                }
            }
            .store(in: &cancellables)
    }
    
}



