//
//  BookmarkListRow.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/20/25.
//

import KNUTICECore
import SwiftUI

struct BookmarkListRow: View {
    static let reuseIdentifier = "BookmarkListRow"
    
    let bookmark: Bookmark
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(bookmark.notice.title)
                .font(.footnote)
            
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
