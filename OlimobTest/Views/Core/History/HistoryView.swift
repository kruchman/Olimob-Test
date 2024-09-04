//
//  HistoryView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 31/8/24.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject private var viewModel: HistoryViewModel
    
    init(viewModel: HistoryViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack(spacing: 30) {
                title
                Divider()
                    .background(.white)
                Spacer()
                if !viewModel.records.isEmpty {
                    VStack {
                        ChartLoadingView(record: $viewModel.selectedRecord)
                        recordsScrollView
                    }
                } else {
                    hint
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.updateRecords()
        }
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel(audioRecorder: AudioRecorder()))
}

//MARK: - Extension

extension HistoryView {
    
    private var title: some View {
        Text("History")
            .font(.title)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.top, 20)
    }
    
    private var hint: some View {
        Text("There is no data here :( ... Save record on 'Audio' tab, and come back here!")
            .font(.headline)
            .fontWeight(.heavy)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
    }
    
    private var recordsScrollView: some View {
        ScrollView {
            ForEach(viewModel.records) { record in
                RecordRowView(record: record)
                    .onTapGesture {
                        viewModel.selectedRecord = record
                    }
            }
        }
        .frame(width: 300, height: 200)
        .cornerRadius(25)
    }
    
}
