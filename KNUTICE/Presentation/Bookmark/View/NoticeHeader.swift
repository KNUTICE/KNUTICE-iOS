//
//  NoticeHeader.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/24/25.
//

import KNUTICECore
import SwiftUI

struct NoticeHeader: View {
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notice.title)
                .bold()
                .font(.subheadline)
            
            HStack {
                Text(notice.department)
                
                Divider()
                
                Text(notice.uploadDate)
                
                Spacer()
            }
            .font(.caption)
            .foregroundStyle(.gray)
        }
        .padding()
        .background(.mainCellBackground)
        .cornerRadius(20)
        .padding()
    }
}

#if DEBUG
#Preview {
    NoticeHeader(
        notice: Notice.generalNoticesSampleData[0]
    )
}
#endif
