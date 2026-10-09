//
//  OptimizationLoadingView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/31/26.
//

import SwiftUI

struct OptimizationLoadingView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center) {
                Text("잠시만 기다려 주세요!")
                    .padding(.bottom)
                Text("서비스를 최적화하고 있어요.")
                Text("작업이 완료될 때까지 조작하지 말고 기다려 주세요.")
                    .padding(.bottom)
                ProgressView()
                    .progressViewStyle(.circular)
            }
            .padding([.leading, .trailing])
            .padding([.top, .bottom], 30)
            .background(.white)
            .cornerRadius(20)
        }
    }
}

#Preview {
    OptimizationLoadingView()
}
