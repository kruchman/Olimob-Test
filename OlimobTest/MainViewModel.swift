//
//  MainViewModel.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 3/9/24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var shouldHintAppear: Bool = false
    let audioRecorder: AudioRecorder
    private var cancellables = Set<AnyCancellable>()
    
    init(audioRecorder: AudioRecorder) {
        self.audioRecorder = audioRecorder
    }
    
    func lookForMessage() {
        audioRecorder.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self else { return }
                if !records.isEmpty && records.count == 1 && !audioRecorder.recording {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.shouldHintAppear = true
                    }
                } else {
                    self.shouldHintAppear = false
                }
            }
            .store(in: &cancellables)
    }
}
