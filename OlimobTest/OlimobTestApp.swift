//
//  OlimobTestApp.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 29/8/24.
//

import SwiftUI

@main
struct OlimobTestApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(audioRecorder: AudioRecorder())
        }
    }
}
