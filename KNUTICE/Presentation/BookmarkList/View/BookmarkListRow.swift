//
//  BookmarkListRow.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import SwiftUI

struct BookmarkListRow: View {
    let bookmark: Bookmark
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 10) {
                Text(bookmark.notice.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                BookmarkSubTitle(bookmark: bookmark)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.red)
                    .frame(width: 13, height: 25)
                
                Triangle()
                    .offset(y: 1)
            }
            .offset(y: -29)
        }
        .padding([.top, .bottom])
        .padding([.leading, .trailing], 16)
        .background(.mainCellBackground)
        .cornerRadius(10)
    }
}

fileprivate struct Triangle: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 25))
            path.addLine(to: CGPoint(x: 13, y: 25))
            path.addLine(to: CGPoint(x: 6.5, y: 19))
        }
        .foregroundStyle(.mainCellBackground)
        .frame(width: 13, height: 25)
    }
}


fileprivate struct BookmarkSubTitle: View {
    let bookmark: Bookmark
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "alarm")
            
            Text(bookmark.alarmDate?.dateTime ?? "없음")
        }
        .font(.caption2)
        .foregroundStyle(.gray)
    }
}

#if DEBUG
#Preview {
    BookmarkListRow(bookmark: Bookmark.sample)
}
#endif
