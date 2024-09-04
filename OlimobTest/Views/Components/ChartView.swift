//
//  ChartView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import SwiftUI
import Charts

struct ChartLoadingView: View {
    @Binding var record: Record?
    
    var body: some View {
        ZStack {
            if let record {
                ChartView(record: record)
            }
        }
    }
}

struct ChartView: View {
    
    var record: Record
    @State private var currentSecond: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            soundData
            chart
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .padding()
        .onAppear {
            startTimer()
        }
        .onChange(of: record) {
            stopTimer()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
}

#Preview {
    ChartView(record: (Record(id: UUID().uuidString,
                            sounds: [
                                Sound(id: UUID().uuidString, volume: 50, onSecond: 1),
                                Sound(id: UUID().uuidString, volume: 20, onSecond: 2),
                                Sound(id: UUID().uuidString, volume: 44, onSecond: 3),
                                Sound(id: UUID().uuidString, volume: 80, onSecond: 4),
                                Sound(id: UUID().uuidString, volume: 10, onSecond: 5)
    ],
                             duration: 5,
                             date: Date())))
}

//MARK: - Extension

extension ChartView {
    
    //MARK: - Properties
    
    private var soundData: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("maxDb:")
                        .font(.caption)
                    Text("\(record.maxDb ?? 0) dB")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("minDb:")
                        .font(.caption)
                    Text("\(record.minDb ?? 0) dB")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 40)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("avg:")
                        .font(.caption)
                    Text("\(record.averageDb ?? 0) dB")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("duration:")
                        .font(.caption)
                    Text("\(record.duration) s")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            
            }
            .padding(.horizontal, 40)
        }
    }
    
    private var chart: some View {
        Chart(record.sounds) { sound in
            LineMark(
                x: .value("Time (s)", sound.onSecond),
                y: .value("Volume (dB)", sound.volume)
            )
            .interpolationMethod(.catmullRom)
            if let currentSound = record.sounds.first(where: { $0.onSecond == currentSecond }) {
                
                RuleMark(y: .value("Current Volume", currentSound.volume))
                    .foregroundStyle(.gray)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                
                RuleMark(x: .value("Current Time", currentSound.onSecond))
                    .foregroundStyle(.gray)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: 1))
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXScale(domain: 1...record.duration)
        .chartXAxisLabel {
            Text("Time (s)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .chartYAxisLabel {
            Text("Volume (dB)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .padding()
    }
    
    //MARK: - Methods
    
    func startTimer() {
        currentSecond = 1
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if currentSecond < record.duration {
                withAnimation(.linear(duration: 1)) {
                    currentSecond += 1
                }
            } else {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
