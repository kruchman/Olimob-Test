//
//  TabSelectionView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 3/9/24.
//

import SwiftUI

struct TabSelectionView: View {
    
    @ObservedObject var tabManager = TabManager.shared
    @Binding var tabSelectionViewShouldAppear: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.black.opacity(0.15))
                .frame(maxWidth: .infinity)
                .frame(height: 80)
            
            HStack(spacing: 15) {
                audioTabIcon
                historyTabIcon
                cleanerTabIcon
                settingsTabIcon
                xmark
            }
            .font(.title2)
            .foregroundStyle(.orange)
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TabSelectionView(tabSelectionViewShouldAppear: .constant(true))
//        .preferredColorScheme(.dark)
}

//MARK: - Extension

extension TabSelectionView {
    
    private var audioTabIcon: some View {
        Image(systemName: "waveform")
            .fontWeight(tabManager.selectedTab == Tab.audio.rawValue ? .bold : .regular)
            .opacity(tabManager.selectedTab == Tab.audio.rawValue ? 1 : 0.5)
            .padding()
            .onTapGesture {
                tabManager.selectedTab = Tab.audio.rawValue
            }
    }
    
    private var historyTabIcon: some View {
        Image(systemName: "clock.fill")
            .fontWeight(tabManager.selectedTab == Tab.history.rawValue ? .bold : .regular)
            .opacity(tabManager.selectedTab == Tab.history.rawValue ? 1 : 0.5)
            .padding()
            .onTapGesture {
                tabManager.selectedTab = Tab.history.rawValue
            }
    }
    
    private var cleanerTabIcon: some View {
        Image(systemName: "bolt.heart")
            .fontWeight(tabManager.selectedTab == Tab.cleaner.rawValue ? .bold : .regular)
            .opacity(tabManager.selectedTab == Tab.cleaner.rawValue ? 1 : 0.5)
            .padding()
            .onTapGesture {
                tabManager.selectedTab = Tab.cleaner.rawValue
            }
    }
    
    private var settingsTabIcon: some View {
        Image(systemName: "gear")
            .fontWeight(tabManager.selectedTab == Tab.settings.rawValue ? .bold : .regular)
            .opacity(tabManager.selectedTab == Tab.settings.rawValue ? 1 : 0.5)
            .padding()
            .onTapGesture {
                tabManager.selectedTab = Tab.settings.rawValue
            }
    }
    
    private var xmark: some View {
        Circle()
            .fill(.black.opacity(0.3))
            .frame(width: 40)
            .overlay(
                Image(systemName: "xmark")
            )
            .padding()
            .onTapGesture {
                tabSelectionViewShouldAppear = false
            }
    }
}
