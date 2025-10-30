//
//  EmptyBookmarkView.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/28/25.
//

import SwiftUI

struct EmptyBookmarkView: View {
    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("Bookmark_3D")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Text("북마크가 존재하지 않아요")
                    .foregroundStyle(.gray)
                    .bold()
            }
            .offset(y: -44)
        }
    }
}

#Preview {
    EmptyBookmarkView()
}
