//
//  SpinningIndicator.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import SwiftUI

struct SpinningIndicator: View {
    @State private var degree: Int = 270
    @State private var spinnerLength: Double = 0.6
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
            
            Circle()
                .trim(from: 0.0, to: spinnerLength)
                .stroke(.white, style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .animation(Animation.easeIn(duration: 1).repeatForever(autoreverses: true), value: degree)
                .frame(width: 40,height: 40)
                .rotationEffect(Angle(degrees: Double(degree)))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: degree)
                .onAppear{
                    degree = 270 + 360
                    spinnerLength = 0
                }
                .offset(y: -34)
        }
    }
}

#Preview {
    SpinningIndicator()
}
