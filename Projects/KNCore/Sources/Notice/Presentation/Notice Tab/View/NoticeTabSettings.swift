//
//  NoticeTabSettings.swift
//  KNCore
//
//  Created by 이정훈 on 4/12/26.
//

import KNDesignSystem
import KNDomain
import KNUtility
import SwiftUI

struct NoticeTabSettings: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var noticeTabItems: NoticeTabItems
    
    init(noticeTabItems: NoticeTabItems) {
        self.noticeTabItems = noticeTabItems
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(noticeTabItems.selectedMajors, id: \.id) {
                        Text($0.tabTitle)
                    }
                    .onDelete { indexSet in
                        let targetsToDeactivate = indexSet.map { noticeTabItems.selectedMajors[$0] }
                        withAnimation {
                            noticeTabItems.removeMajor(at: indexSet)
                        }
                        Task {
                            for target in targetsToDeactivate {
                                await noticeTabItems.deactiveTopic(of: target)
                            }
                        }
                    }
                } header: {
                    Text("선택한 학과")
                }
                .listSectionSeparator(.visible, edges: .bottom)
                
                ForEach(College.allCases, id: \.self) { college in
                    Section {
                        ForEach(noticeTabItems.availableMajors(for: college), id: \.id) { major in
                            MajorSelectionRow(title: major.localizedDescription) {
                                guard noticeTabItems.isAddable else { return }
                                
                                Task {
                                    await noticeTabItems.activeTopic(of: major)
                                    withAnimation {
                                        noticeTabItems.insertAfterLastMajorCategory(newItem: CategoryItem.category(major))
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    } header: {
                        Text(college.localizedDescription)
                    }
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
            .alert(isPresented: $noticeTabItems.isShowingAlert) {
                Alert(title: Text("알림"), message: Text(noticeTabItems.alertMessage))
            }
        }
    }
}

fileprivate struct MajorSelectionRow: View {
    @Environment(\.editMode) private var editMode
    
    let title: String
    let selectAction: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Button {
                selectAction()
            } label: {
                Text("선택")
                    .font(.subheadline)
                    .foregroundStyle(editMode?.wrappedValue.isEditing == true ? KNDesignSystemAsset.gray5.swiftUIColor : KNDesignSystemAsset.accent2.swiftUIColor)
            }
            .disabled(editMode?.wrappedValue.isEditing == true)
        }
    }
}

#Preview {
    NoticeTabSettings(noticeTabItems: NoticeTabItems(.init(value: [])))
}
