//
//  NotificationSubscriptionList.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import SwiftUI

struct NotificationSubscriptionList: View {
    @StateObject private var viewModel: NotificationSubscriptionListViewModel
    
    init(viewModel: NotificationSubscriptionListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            List {
                Section {
                    Toggle(isOn: Binding(get: {
                        viewModel.isGeneralNoticeNotificationSubscribed ?? false
                    }, set: {
                        viewModel.update(key: .generalNotice, value: $0)
                    }), label: {
                        Text("일반공지")
                    })
                    
                    Toggle(isOn: Binding(get: {
                        viewModel.isAcademicNoticeNotificationSubscribed ?? false
                    }, set: {
                        viewModel.update(key: .academicNotice, value: $0)
                    }), label: {
                        Text("학사공지")
                    })
                    
                    Toggle(isOn: Binding(get: {
                        viewModel.isScholarshipNoticeNotificationSubscribed ?? false
                    }, set: {
                        viewModel.update(key: .scholarshipNotice, value: $0)
                    }), label: {
                        Text("장학안내")
                    })
                    
                    Toggle(isOn: Binding(get: {
                        viewModel.isEventNoticeNotificationSubscribed ?? false
                    }, set: {
                        viewModel.update(key: .eventNotice, value: $0)
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
                .listRowBackground(Color.detailViewBackground)
            }
            .background(.detailViewBackground)
            .tint(.accent2)
            .listStyle(.plain)
            .navigationTitle("서비스 알림")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "isInitializedNotificationSettings") {
                    viewModel.initializeAndFetchNotificationSubscriptions()
                } else if !viewModel.isAllDataLoaded {
                    viewModel.fetchNotificationSubscriptions()
                }
            }
            
            if viewModel.isLoading {
                SpinningIndicator()
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSubscriptionList(viewModel: NotificationSubscriptionListViewModel())
    }
}
