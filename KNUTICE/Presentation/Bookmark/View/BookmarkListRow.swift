//
//  BookmarkListRow.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/5/25.
//

import SwiftUI

struct BookmarkListRow: View {
    @Binding var reminder: Bookmark
    
    var body: some View {
        HStack(spacing: 15) {
            ReminderButton(reminder: $reminder)
            
            VStack(alignment: .leading, spacing: 7) {
                Text(reminder.title)
                    .strikethrough(reminder.isCompleted)
                
                ReminderSubTitle(reminder: reminder)
            }
            
            Spacer()
            
            if let noticeKind = reminder.noticeKind {
                Rectangle()
                    .foregroundStyle(getNoticeColor(of: noticeKind))
                    .frame(width: 13, height: 25)
                    .offset(y: -28)
            }
        }
        .padding()
        .background(.mainCellBackground)
        .cornerRadius(10)
    }
}

fileprivate struct ReminderButton: View {
    @Binding var reminder: Bookmark
    
    var body: some View {
        Button {
            reminder.isCompleted.toggle()
            //Local Database 수정
        } label: {
            if reminder.isCompleted {
                Circle()
                    .foregroundStyle(.accent2)
                    .frame(width: 25, height: 25)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                    }
            } else {
                Circle()
                    .stroke(.gray, lineWidth: 2)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.white)
            }
        }
    }
}

fileprivate struct ReminderSubTitle: View {
    let reminder: Bookmark
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "calendar")
                .foregroundStyle(.accent2)
            
            Text(reminder.date.shortDate)
                .foregroundStyle(.accent2)
            
            if reminder.isAlarmOn {
                Image(systemName: "alarm")
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
            }
        }
        .font(.footnote)
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
    BookmarkListRow(reminder: Binding(get: { Bookmark.sample }, set: { _ in }))
}
