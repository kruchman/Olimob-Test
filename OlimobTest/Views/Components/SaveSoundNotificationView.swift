//
//  SaveSoundNotificationView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 30/8/24.
//

import SwiftUI

struct SaveSoundNotificationView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.black.opacity(0.45))
                .frame(maxWidth: .infinity)
                .frame(height: 80)
            
            HStack(spacing: 25) {
                Image(systemName: "waveform")
                    .font(.title)
                
                Text("Saved to history, you can see details about this record on History tab.")
                    .font(.callout)
            }
            .foregroundStyle(.white)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
    }
}

#Preview {
    SaveSoundNotificationView()
}
