//
//  CleanerView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import SwiftUI

struct CleanerView: View {
    
    @StateObject private var viewModel: CleanerViewModel
    
    init(viewModel: CleanerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack(spacing: 30) {
                titleSection
                Divider()
                    .background(.white)
                VStack {
                    progressBarHint
                    progressBar
                }
                .opacity(viewModel.isButtonTapped ? 1 : 0)
                .animation(.easeIn, value: viewModel.isButtonTapped)
                
                VStack(spacing: 30) {
                    powerButton
                    
                    buttonHint
                }
                .padding(.top, 70)
                
                Spacer()
            }
        }
        .onChange(of: viewModel.isButtonTapped) {
            if viewModel.isButtonTapped {
                viewModel.buttonTapped()
                viewModel.startHapticFeedback()
            } else {
                viewModel.stopTheTimer()
                viewModel.stopHapticFeedback()
            }
        }
    }
}

#Preview {
    CleanerView(viewModel: CleanerViewModel())
}

//MARK: - Extension

extension CleanerView {
    
    private var titleSection: some View {
        Text("Cleaner")
            .font(.title)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.top, 20)
    }
    
    private var progressBarHint: some View {
        Text("It is highly recommended to use cleaner only for 10 seconds!")
            .font(.title3)
            .foregroundStyle(viewModel.buttonActivityTime == 10 ? .red : .white)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.top, 30)
    }
    
    private var progressBar: some View {
        ProgressView(value: viewModel.progressBarValue, total: 1)
            .tint(.orange)
            .background(.white.opacity(0.5))
            .padding(.horizontal, 40)
            .shadow(color: .white.opacity(0.3), radius: 5)
            .animation(.linear, value: viewModel.progressBarValue)
    }
    
    private var powerButton: some View {
        ZStack {
            Circle()
                .foregroundStyle(viewModel.isButtonTapped ?
                    .orange : .black.opacity(0.2))
                .frame(width: 220)
                .shadow(color: .white.opacity(0.5), radius: 5)
            
            Image(systemName: "power")
                .font(.system(size: 50))
                .foregroundStyle(viewModel.isButtonTapped ?
                    .blue : .white)
        }
        .onTapGesture {
            viewModel.isButtonTapped.toggle()
        }
    }
    
    private var buttonHint: some View {
        Text("Tap the button above to activate/deactivate blower")
            .font(.headline)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
    }
    
    
    
}
