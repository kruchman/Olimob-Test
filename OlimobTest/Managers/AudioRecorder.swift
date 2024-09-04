//
//  AudioRecorder.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

final class AudioRecorder: ObservableObject {
    
    @Published var records: [Record] = []
    @Published var currentDb: Int = 0
    
    let coreDataManager = CoreDataManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var timer: Timer?
    private var startTime: Date?
    private var currentSounds: [Sound] = []
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    private var audioRecorder: AVAudioRecorder!
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    init() {
        fetchRecordsFromCoreData()
    }
    
    private func setUpAndStartRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set your recording session.")
        }
        
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = docPath.appendingPathComponent("\(Date().timeIntervalSince1970) Record.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: 128000,  // 128 kbps
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            recording = true
        } catch {
            print("Couldn't start recording")
        }
    }
    
    private func stopRecording() {
        audioRecorder.stop()
        recording = false
    }
    
    func startNewRecording() {
        startTime = Date()
        currentSounds = []
        setUpAndStartRecording()
        startMonitoring()
    }
    
    func stopMonitoringAndSaveRecording() {
        stopRecording()
        timer?.invalidate()
        
        guard let startTime = startTime else { return }
        let duration = Int(Date().timeIntervalSince(startTime))
        let date = Date()
        currentSounds.sort(by: { $0.onSecond < $1.onSecond })
        let newRecord = Record(id: UUID().uuidString, sounds: currentSounds, duration: duration, date: date)
        coreDataManager.addRecordToDB(record: newRecord)
        fetchRecordsFromCoreData()
    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, self.recording else {
                timer.invalidate()
                return
            }
            self.audioRecorder.updateMeters()
            currentDb = Int(self.audioRecorder.averagePower(forChannel: 0))
            HapticsManager.shared.triggerHapticFeedback(hapticsPower: .medium)
            let second = Int(Date().timeIntervalSince(self.startTime ?? Date()))
            let sound = Sound(id: UUID().uuidString, volume: currentDb, onSecond: second)
            self.currentSounds.append(sound)
        }
    }
    
    private func fetchRecordsFromCoreData() {
        coreDataManager.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] savedEntities in
                self?.records = savedEntities.compactMap { entity in
                    self?.coreDataManager.getRecordFromEntity(entity)
                }
            }
            .store(in: &cancellables)
    }
    
}

