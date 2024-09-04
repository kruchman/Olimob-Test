//
//  MainView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 29/8/24.
//

import SwiftUI
import Combine

struct MainView: View {
    
    let audioRecorder: AudioRecorder
    @StateObject var viewModel: MainViewModel
    @State private var tabSelection = TabManager.shared.selectedTab
    @State private var isRecordButtonTapped: Bool = false
    
    init(audioRecorder: AudioRecorder) {
        self.audioRecorder = audioRecorder
        self._viewModel = StateObject(wrappedValue: MainViewModel(audioRecorder: audioRecorder))
        UITabBar.appearance().unselectedItemTintColor = UIColor.secondarySystemBackground
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                AudioView(viewModel: AudioViewModel(audioRecorder: audioRecorder),
                          isRecordButtonTapped: $isRecordButtonTapped)
                    .tabItem { Image(systemName: "waveform") }
                    .tag(Tab.audio.rawValue)
                
                HistoryView(viewModel: HistoryViewModel(audioRecorder: audioRecorder))
                    .tabItem { Image(systemName: "clock.fill") }
                    .tag(Tab.history.rawValue)
                
                CleanerView(viewModel: CleanerViewModel())
                    .tabItem { Image(systemName: "bolt.heart") }
                    .tag(Tab.cleaner.rawValue)
                
                SettingsView(viewModel: SettingsViewModel(audioRecorder: audioRecorder))
                    .tabItem { Image(systemName: "gear") }
                    .tag(Tab.settings.rawValue)
            }
            .tint(.orange)
            .onChange(of: viewModel.shouldHintAppear) {
                if viewModel.shouldHintAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            viewModel.shouldHintAppear = false
                        }
                    }
                }
            }
            .onChange(of: isRecordButtonTapped) {
                if isRecordButtonTapped {
                    viewModel.lookForMessage()
                }
            }
            if viewModel.shouldHintAppear {
                VStack {
                    SaveSoundNotificationView()
                        .padding(.top, 50)
                    
                    Spacer()
                }
                .transition(.move(edge: .top))
                .zIndex(1)
            }
            
        }
    }
}

#Preview {
    MainView(audioRecorder: AudioRecorder())
}


