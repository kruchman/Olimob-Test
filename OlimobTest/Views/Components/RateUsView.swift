//
//  RateUsView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 4/9/24.
//

import SwiftUI

struct RateUsView: View {
    
    @State private var evaluation: Int = 3
    @Binding var rateUsViewShouldAppear: Bool
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack(spacing: 50) {
                Spacer()
                Text("Enjoying our App?")
                    .font(.title)
                    .foregroundStyle(.white)
                    smileView
                Text("Rate Us!")
                    .font(.title)
                    .foregroundStyle(.white)
                starsView
                Spacer()
                submitButton
            }
        }
        .overlay(xmarkButton, alignment: .topTrailing)
    }
}

#Preview {
    RateUsView(rateUsViewShouldAppear: .constant(false))
}

//MARK: - Extension

extension RateUsView {
    
    private var smileView: some View {
        Text(evaluation >= 4 ? "😊" : evaluation == 3 ? "😐" : "☹️")
            .font(.system(size: 150))
    }
    
    private var starsView: some View {
        HStack(spacing: 20) {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .font(.title)
                    .foregroundColor(evaluation >= index ? Color.yellow : Color.secondary)
                    .onTapGesture {
                        evaluate(index: index)
                    }
            }
        }
    }
    
    private var submitButton: some View {
        Button("Submit") {
            
        }
        .font(.title2)
        .foregroundStyle(.white)
        .frame(width: 250, height: 60)
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
        .padding(.bottom, 30)
    }
    
    private var xmarkButton: some View {
        ZStack {
            Circle()
                .fill(.secondary)
                .frame(width: 50)
            Image(systemName: "xmark")
                .font(.title)
                .foregroundStyle(.white.opacity(0.7))
        }
            .padding()
            .onTapGesture {
                rateUsViewShouldAppear = false
            }
    }
    
    func evaluate(index: Int) {
        evaluation = index
    }
}
