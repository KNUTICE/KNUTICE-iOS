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
            if let category = bookmark.notice.noticeCategory {
                category.color
                    .frame(width: 8)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(bookmark.notice.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                BookmarkSubTitle(bookmark: bookmark)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .bottom, .trailing])
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(.mainCellBackground)
        .cornerRadius(10)
    }
}

@available(*, deprecated)
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

fileprivate extension NoticeCategory {
    var color: Color {
        switch self {
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
}

#if DEBUG
#Preview {
    BookmarkListRow(bookmark: Bookmark.sample)
}
#endif
