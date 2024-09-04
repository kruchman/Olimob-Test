//
//  Tab.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 3/9/24.
//

import Foundation

final class TabManager: ObservableObject {
    
    static let shared = TabManager()
    
    private let selectedTabKey = "selectedTab"
    
    @Published var selectedTab: String {
        didSet {
            UserDefaults.standard.set(selectedTab, forKey: selectedTabKey)
        }
    }
    
    private init() {
        selectedTab = UserDefaults.standard.string(forKey: selectedTabKey) ?? Tab.audio.rawValue
    }
}



