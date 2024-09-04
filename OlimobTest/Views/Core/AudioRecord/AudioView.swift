//
//  AudioView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 29/8/24.
//

import SwiftUI

struct AudioView: View {
    
    @StateObject var viewModel: AudioViewModel
    @Binding var isRecordButtonTapped: Bool
    
    init(viewModel: AudioViewModel, isRecordButtonTapped: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isRecordButtonTapped = Binding(projectedValue: isRecordButtonTapped)
    }
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack(spacing: 30) {
                titleSection
                Divider()
                    .background(.white)
                Spacer()
                hintsSection
                DbCircleView(db: $viewModel.currentDb)
                recordButton
                Spacer()
            }
        }
    }
}

#Preview {
    AudioView(viewModel: AudioViewModel(audioRecorder: AudioRecorder()),
              isRecordButtonTapped: .constant(false))
}

//MARK: - Extension

extension AudioView {
    
    private var recordingCircleView: some View {
        Circle()
            .fill(.red)
            .frame(width: 30, height: 30)
    }
    
    private var nonRecordingRectangleView: some View {
        Rectangle()
            .fill(.white.opacity(0.3))
            .frame(width: 30, height: 30)
            .cornerRadius(10)
    }
    
    private var titleSection: some View {
        HStack(spacing: 80) {
            recordingCircleView.opacity(0)
            
            Text("Audio")
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            
            if viewModel.isRecording {
                recordingCircleView
            } else {
                nonRecordingRectangleView
            }
        }
        .padding(.top, 20)
    }
    
    private var hintsSection: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("Any value around - 120 dB can be considered silence or very quiet")
                .font(.callout)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            Text("Values closer to 0 dB would mean louder sounds, with 0 dB being the loudest level the microphone can capture without distortion")
                .font(.callout)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 10)
    }
    
    private var recordButton: some View {
        Button(action: {
            if viewModel.isRecording {
                viewModel.stopRecording()
            } else {
                viewModel.startRecording()
            }
            viewModel.isRecording.toggle()
            isRecordButtonTapped.toggle()
        }, label: {
            Text(viewModel.isRecording ? "Stop" : "Record")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 250, height: 60)
                .background(Color.black.opacity(0.2))
                .cornerRadius(15)
        })
    }
}
