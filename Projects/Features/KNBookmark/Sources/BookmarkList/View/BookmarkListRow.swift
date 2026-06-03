//
//  BookmarkListRow.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/20/25.
//

import KNDomain
import KNUtility
import SwiftUI

public struct BookmarkListRow: View {
    public static let reuseIdentifier = "BookmarkListRow"
    
    private let bookmark: Bookmark
    
    public init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(bookmark.notice.title)
                .font(.footnote)
                .lineLimit(1)
            
            HStack(spacing: 5) {
                Image(systemName: "alarm")
                
                if let alarmDate = bookmark.alarmDate {
                    Text(alarmDate.dateTime)
                } else {
                    Text("없음")
                }
                
                Spacer()
            }
            .font(.caption2)
            .foregroundStyle(.gray)
        }
    }
}

#if DEBUG
#Preview {
    BookmarkListRow(bookmark: Bookmark.sample)
}
#endif
