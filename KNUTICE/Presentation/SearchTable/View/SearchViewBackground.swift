//
//  SearchResultsBackgroundView.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/28/25.
//

import SwiftUI

struct SearchViewBackground: View {
    enum Style {
        case notice
        case bookmark
    }
    
    let style: Style
    private var promptText: String {
        switch style {
        case .notice: 
            return "어떤 공지 사항을 찾아드릴까요?"
        case .bookmark: 
            return "어떤 북마크를 찾아드릴까요?"
        }
    }
    
    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("Magnifying_Glasses_3D")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Text(promptText)
                    .bold()
                    .foregroundStyle(.gray)
            }
            .offset(y: -44)
        }
    }
}

#Preview {
    SearchViewBackground(style: .bookmark)
}
