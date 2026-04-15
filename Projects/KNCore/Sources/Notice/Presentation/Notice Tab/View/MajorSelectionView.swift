//
//  MajorSelectionView76.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/26/25.
//

import KNUtility
import SwiftUI

struct MajorSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(NoticeTabItems.self) private var noticeTabItems
    
    var body: some View {
        List {
            ForEach(College.allCases, id: \.self) { college in
                Section {
                    ForEach(college.majors, id: \.self) { major in
                        Button {
                            Task {
                                noticeTabItems.insertAfterLastMajorCategory(newItem: CategoryItem.category(major))
                                await noticeTabItems.activeTopic(of: major)
                                dismiss()
                            }
                        } label: {
                            Text(major.localizedDescription)
                        }
                        .listRowSeparator(.hidden)
                    }
                } header: {
                    Text(college.localizedDescription)
                        .font(.title3)
                        .bold()
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("학과선택")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MajorSelectionView()
        .environment(NoticeTabItems(.init(value: [])))
}
