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
                    Toggle(
                        isOn: Binding(get: {
                            viewModel.isGeneralNoticeNotificationSubscribed ?? false
                        }, set: {
                            viewModel.update(key: .generalNotice, value: $0)
                        }),
                        label: {
                            Text("일반소식")
                        })
                } footer: {
                    Text("일반소식은 학교의 주요 공지와 다양한 안내 사항이 포함됩니다.")
                }
                
                Section {
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isAcademicNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(key: .academicNotice, value: $0)
                            }),
                        label: {
                            Text("학사공지")
                        })
                } footer: {
                    Text("학사 공지는 수강, 성적, 졸업 등 학사 운영과 관련된 중요한 사항이 포함됩니다.")
                }
                
                Section {
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isScholarshipNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(key: .scholarshipNotice, value: $0)
                            }),
                        label: {
                            Text("장학안내")
                        })
                } footer: {
                    Text("장학 안내는 다양한 장학금의 신청 자격, 절차, 일정 등 다양한 공지 사항이 포함됩니다.")
                }
                
                Section {
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isEventNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(key: .eventNotice, value: $0)
                            }),
                        label: {
                            Text("행사안내")
                        })
                } footer: {
                    Text("행사 안내는 학교에서 진행되는 각종 교육, 문화, 진로 등 다양한 행사의 일정에 대한 공지 사항이 포함됩니다.")
                }
                
                Section {
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isEmploymentNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(key: .employmentNotice, value: $0)
                            }),
                        label: {
                            Text("취업안내")
                        }
                    )
                } footer: {
                    Text("취업 안내는 채용 정보, 취업 지원 프로그램, 진로 상담 등 학생들의 진로 설계를 돕기 위한 공지 사항이 포합됩니다.")
                }
            }
            .background(.detailViewBackground)
            .tint(.accent2)
            .navigationTitle("서비스 알림")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "isInitializedNotificationSettings") {
                    viewModel.initializeAndFetchNotificationSubscriptions()
                } else if !viewModel.isAllDataLoaded {
                    viewModel.fetchNotificationSubscriptions()
                }
            }
            .alert("알림 상태를 변경할 수 없어요.", isPresented: $viewModel.isShowingAlert) {
                Button("확인") {}
            } message: {
                Text(viewModel.alertMessage)
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
