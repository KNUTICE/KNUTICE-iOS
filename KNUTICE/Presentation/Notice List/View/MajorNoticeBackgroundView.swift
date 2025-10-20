//
//  MajorNoticeBackgroundView.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/20/25.
//

import SwiftUI

struct MajorNoticeBackgroundView: View {
    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("plus-dynamic-clay")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Text("좌측 상단에서 학과를 선택해 주세요.")
                    .foregroundStyle(.gray)
                    .bold()
            }
            .offset(y: -44)
        }
    }
}

#Preview {
    MajorNoticeBackgroundView()
}
