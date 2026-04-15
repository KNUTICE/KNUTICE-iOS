//
//  NoticeTabSettings.swift
//  KNCore
//
//  Created by 이정훈 on 4/12/26.
//

import KNUtility
import SwiftUI

struct NoticeTabSettings: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(NoticeTabItems.self) private var noticeTabItems
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let noticeTabs = noticeTabItems.categories.compactMap { item -> (any NoticeTabRepresentable)? in
                        if case let .category(representable) = item, representable is MajorCategory {
                            return representable
                        }
                        
                        return nil
                    }

                    ForEach(noticeTabs, id: \.id) {
                        Text($0.tabTitle)
                    }
                    .onDelete { indexSet in
                        Task {
                            let targetsToDeactivate = indexSet.map { noticeTabs[$0] }
                            for target in targetsToDeactivate {
                                if let major = target as? MajorCategory {
                                    await noticeTabItems.deactiveTopic(of: major)
                                }
                            }
                            noticeTabItems.removeMajor(at: indexSet)
                        }
                    }
                    
                    NavigationLink("학과 추가") {
                        MajorSelectionView()
                            .environment(noticeTabItems)
                    }
                } header: {
                    Text("학과 공지")
                }
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("공지 항목 관리")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NoticeTabSettings()
        .environment(NoticeTabItems(.init(value: [])))
}
