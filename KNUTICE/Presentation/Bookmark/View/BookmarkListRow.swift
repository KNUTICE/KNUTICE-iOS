//
//  BookmarkListRow.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import SwiftUI

struct BookmarkListRow: View {
    @Binding var bookmark: Bookmark
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 7) {
                Text(bookmark.notice.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                BookmarkSubTitle(bookmark: bookmark)
            }
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.red)
                    .frame(width: 13, height: 25)
                
                Triangle()
            }
            .offset(y: -29)
        }
        .padding()
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
            
            Text(bookmark.alarmDate?.shortDate ?? "없음")
        }
        .font(.footnote)
        .foregroundStyle(.gray)
    }
}

fileprivate func getNoticeColor(of kind: NoticeKind) -> Color {
    switch kind {
    case .generalNotice:
        return .salmon
    case .academicNotice:
        return .lightOrange
    case .scholarshipNotice:
        return .lightGreen
    case .eventNotice:
        return .dodgerBlue
    }
}

#Preview {
    BookmarkListRow(bookmark: Binding(get: { Bookmark.sample }, set: { _ in }))
}
