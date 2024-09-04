//
//  Record.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import Foundation

struct Record: Identifiable, Equatable {
    let id: String
    var sounds: [Sound]
    let duration: Int
    let date: Date
    
    var maxDb: Int? {
        sounds.map { $0.volume }.max()
    }
    
    var minDb: Int? {
        sounds.map { $0.volume }.min()
    }
    
    var averageDb: Int? {
        guard !sounds.isEmpty else { return nil }
        let total = sounds.map { $0.volume }.reduce(0, +)
        return total / sounds.count
    }
    
    func formattedDate() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            return formatter.string(from: date)
        }

}
