//
//  RecordRowView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 4/9/24.
//

import SwiftUI

struct RecordRowView: View {
    
    var record: Record
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "waveform")
                .font(.title)
                .foregroundStyle(.orange)
            VStack {
                Text("date of creation:")
                    .font(.headline)
                Text("\(record.formattedDate())")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
            }
            
        }
        .frame(width: 250, height: 80)
        .background(Material.ultraThin)
        .cornerRadius(15)
    }
}

#Preview {
    RecordRowView(record: Record(id: UUID().uuidString,
                                           sounds: [Sound(id: UUID().uuidString, volume: -30, onSecond: 1),
                                                    Sound(id: UUID().uuidString, volume: -70, onSecond: 2),
                                                    Sound(id: UUID().uuidString, volume: -20, onSecond: 3),
                                                    Sound(id: UUID().uuidString, volume: -80, onSecond: 4),
                                                    Sound(id: UUID().uuidString, volume: -5, onSecond: 5),],
                                           duration: 5,
                                           date: Date()))
}
