//
//  SpinningIndicator.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/21/24.
//

import SwiftUI

struct SpinningIndicator: View {
    @State private var rotation: Double = 0
    @State private var trimEnd: CGFloat = 0.6
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            Circle()
                .trim(from: 0.0, to: trimEnd)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    startAnimation()
                }
                .offset(y: -34)
        }
    }
    
    private func startAnimation() {
        guard !isAnimating else { return }
        
        isAnimating = true
        
        // 회전 애니메이션
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        // 트림 길이 애니메이션
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            trimEnd = 0.9
        }
    }
}

#Preview {
    SpinningIndicator()
}
