//
//  DbCircleView.swift
//  OlimobTest
//
//  Created by Юрий Кручинин on 29/8/24.
//

import SwiftUI

struct DbCircleView: View {
    
    @Binding var db: Int
    var circleTrim: CGFloat {
            return CGFloat(1 - (Double(db) + 160) / 160)
        }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: circleTrim, to: 1)
                .stroke(lineWidth: 15)
                .foregroundStyle(.orange)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 250)
                .animation(.bouncy, value: circleTrim)
            
            Text("\(db) dB")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .onChange(of: db) {
            HapticsManager.shared.triggerHapticFeedback(hapticsPower: db > -60 ? .heavy :
                                                            db > -110 ? .medium : .light)
        }
    }
}

#Preview {
    DbCircleView(db: .constant(50))
        .preferredColorScheme(.dark)
}
