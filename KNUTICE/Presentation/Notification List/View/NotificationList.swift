//
//  NotificationList.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import SwiftUI

struct NotificationList: View {
    @StateObject private var viewModel: NotificationListViewModel
    
    init(viewModel: NotificationListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: Binding(get: {
                    viewModel.isGeneralNoticeNotificationAllowed ?? false
                }, set: { _ in
                    
                }), label: {
                    Text("일반공지")
                })
                
                Toggle(isOn: Binding(get: {
                    viewModel.isAcademicNoticeNotificationAllowd ?? false
                }, set: { _ in
                    
                }), label: {
                    Text("학사공지")
                })
                
                Toggle(isOn: Binding(get: {
                    viewModel.isScholarshipNoticeNotificationAllowed ?? false
                }, set: { _ in
                    
                }), label: {
                    Text("장학안내")
                })
                
                Toggle(isOn: Binding(get: {
                    viewModel.isEventNoticeNotificationAllowed ?? false
                }, set: { _ in
                    
                }), label: {
                    Text("행사안내")
                })
            } footer: {
                Text("새로운 공지사항이 등록되면 푸시 알림으로 알려드려요.")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .padding([.top, .bottom])
            .listSectionSeparator(.hidden, edges: .bottom)
        }
        .tint(.toggle)
        .listStyle(.plain)
        .navigationTitle("서비스 알림")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !viewModel.isAllDataLoaded {
                viewModel.getNotificationPermissions()
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationList(viewModel: AppDI.shared.makeNotificationListViewModel())
    }
}
