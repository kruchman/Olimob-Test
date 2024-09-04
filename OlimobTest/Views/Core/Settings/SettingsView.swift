//
//  SettingsView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Color.blue.ignoresSafeArea()
                VStack(spacing: 30) {
                    titleSection
                    Divider()
                        .background(.white)
                        .padding(.bottom, 20)
                    VStack(spacing: 30) {
                        customizationSection
                        communitySection
                        legalSection
                        historySection
                    }
                    Spacer()
                }
            }
            .blur(radius: viewModel.tabSelectionViewShouldAppear ? 5 : 0)
            if viewModel.tabSelectionViewShouldAppear {
                TabSelectionView(tabSelectionViewShouldAppear: $viewModel.tabSelectionViewShouldAppear)
                    .zIndex(1)
                    .transition(.move(edge: .trailing))
            }
        }
        .fullScreenCover(isPresented: $viewModel.rateUsViewShouldAppear) {
            RateUsView(rateUsViewShouldAppear: $viewModel.rateUsViewShouldAppear)
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(audioRecorder: AudioRecorder()))
}

//MARK: - Extension

extension SettingsView {
    
    private var titleSection: some View {
        Text("Cleaner")
            .font(.title)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.top, 20)
    }
    
    private var customizationSection: some View {
        VStack {
            Text("Customization")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            HStack {
                HStack {
                    Image(systemName: "house.fill")
                        .foregroundStyle(.white)
                    Text("Primary Tab")
                        .foregroundStyle(.white)
                }
                Spacer()
                HStack {
                    Text(viewModel.tabManager.selectedTab.capitalized)
                        .foregroundStyle(.white)
  
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.orange)
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.tabSelectionViewShouldAppear.toggle()
                    }
                }
            }
            .padding()
            
            divider
            
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.white)
                Spacer()
                Toggle("Haptics", isOn: $viewModel.isHapticsOn)
                    .foregroundStyle(.white)
                    .tint(.orange)
                    .onChange(of: viewModel.isHapticsOn) {
                        print("Old value \(HapticsManager.shared.isHapticsEnabled)")
                        HapticsManager.shared.isHapticsEnabled = !HapticsManager.shared.isHapticsEnabled
                        print("New value \(HapticsManager.shared.isHapticsEnabled)")
                    }
            }
            .padding()
        }
    }
    
    private var communitySection: some View {
        VStack {
            Text("Community")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            HStack {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.white)
                    Text("Rate Our App")
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                        .foregroundStyle(.orange)
            }
            .padding()
            .background(Color.white.opacity(0.001))
            .onTapGesture {
                viewModel.rateUsViewShouldAppear.toggle()
            }
            
            divider
            
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(.white)
                Text("Support")
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.right")
                        .foregroundStyle(.orange)
            }
            .padding()
        }
    }
    
    private var legalSection: some View {
        VStack {
            Text("Leagal")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            HStack {
                HStack {
                    Image(systemName: "person.badge.shield.checkmark.fill")
                        .foregroundStyle(.white)
                    Text("Privacy Policy")
                        .foregroundStyle(.white)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.orange)
                
            }
            .padding()
        }
    }
    
    private var historySection: some View {
        VStack {
            Text("History")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            Button("Clear History") {
                viewModel.deleteAllrecords()
            }
            .font(.title3)
            .foregroundStyle(.blue)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
    }
    
    private var divider: some View {
        Divider()
            .frame(height: 1.5)
            .background(.white)
            .padding(.horizontal)
    }
}
