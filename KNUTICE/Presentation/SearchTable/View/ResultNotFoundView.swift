//
//  ResultNotFoundView.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/28/25.
//

import SwiftUI

struct ResultNotFoundView: View {
    var body: some View {
        ZStack {
            Color.primaryBackground
            
            VStack(spacing: 30) {
                ZStack {
                    Image("file-text-front-clay")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    
                    Image("zoom-front-clay")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .offset(x: -50, y: 30)
                }
                .offset(x: 20)
                
                Text("검색 결과가 없어요")
                    .bold()
                    .foregroundStyle(.gray)
            }
            .offset(y: -44)
        }
    }
}

#Preview {
    ResultNotFoundView()
}
