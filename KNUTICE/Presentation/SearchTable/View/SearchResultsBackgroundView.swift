//
//  SearchResultsBackgroundView.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/28/25.
//

import SwiftUI

struct SearchResultsBackgroundView: View {
    var body: some View {
        ZStack {
            Color.mainBackground
            
            VStack(spacing: 20) {
                Image("Magnifying_Glasses_3D")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Text("어떤 공지 사항을 찾아드릴까요?")
                    .bold()
                    .foregroundStyle(.gray)
            }
            .offset(y: -44)
        }
    }
}

#Preview {
    SearchResultsBackgroundView()
}
