//
//  NotificationSubscriptionList.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import SwiftUI
import KNUTICECore

struct TopicSubscriptionList: View {
    @StateObject private var viewModel: TopicSubscriptionListViewModel
    
    init(viewModel: TopicSubscriptionListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            List {
                Section {
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isGeneralNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(of: .notice, topic: NoticeCategory.generalNotice, isEnabled: $0)
                            }
                        ), label: {
                            ToggleCaption(
                                title: "일반소식",
                                caption: "학교의 주요 공지와 관련된 다양한 소식을 알려드려요."
                            )
                        })
                    
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isAcademicNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(of: .notice, topic: NoticeCategory.academicNotice, isEnabled: $0)
                            }
                        ), label: {
                            ToggleCaption(
                                title: "학사공지",
                                caption: "수강, 성적, 졸업 등 학사 운영과 관련된 다양한 소식을 알려드려요."
                            )
                        })
                    
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isScholarshipNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(of: .notice, topic: NoticeCategory.scholarshipNotice, isEnabled: $0)
                            }
                        ), label: {
                            ToggleCaption(
                                title: "장학안내",
                                caption: "장학금의 신청 자격, 절차, 일정 등과 관련된 다양한 소식을 알려드려요."
                            )
                        })
                    
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isEventNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(of: .notice, topic: NoticeCategory.eventNotice, isEnabled: $0)
                            }
                        ), label: {
                            ToggleCaption(
                                title: "행사안내",
                                caption: "학교에서 진행되는 각종 교육, 문화, 진로와 관련된 다양한 소식을 알려드려요."
                            )
                        })
                    
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isEmploymentNoticeNotificationSubscribed ?? false
                            }, set: {
                                viewModel.update(of: .notice, topic: NoticeCategory.employmentNotice, isEnabled: $0)
                            }
                        ), label: {
                            ToggleCaption(
                                title: "취업안내",
                                caption: "채용 정보, 취업 지원 프로그램, 진로 상담 등 학생들의 진로 설계를 돕기 위한 소식을 알려드려요."
                            )
                        }
                    )
                }
                
                Section {
                    Toggle(
                        isOn: Binding(
                            get: {
                                viewModel.isMajorNoticeNotificationSubscribed ?? false
                            }, set: {
                                if let majorStr = UserDefaults.shared?.string(forKey: UserDefaultsKeys.selectedMajor.rawValue),
                                   let selectedMajor = MajorCategory(rawValue: majorStr) {
                                    viewModel.update(of: .major, topic: selectedMajor, isEnabled: $0)
                                }
                            }),
                        label: {
                            ToggleCaption(
                                title: "학과소식",
                                caption: "학과 소식은 학과의 최신 소식을 알려드려요.\n학과를 변경하고 싶으시면 두 번째 탭에서 원하는 학과를 선택해 주세요."
                            )
                    })
                }
            }
            .background(.primaryBackground)
            .tint(.accent2)
            .navigationTitle("서비스 알림")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchNotificationSubscriptions()
            }
            .onDisappear {
                viewModel.task?.cancel()
            }
            .alert("알림 상태를 변경할 수 없어요.", isPresented: $viewModel.isShowingAlert) {
                Button("확인") {}
            } message: {
                Text(viewModel.alertMessage)
            }
            
            SpinningIndicator()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
    }
}

fileprivate struct ToggleCaption: View {
    let title: String
    let caption: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
            
            Text(caption)
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        TopicSubscriptionList(viewModel: TopicSubscriptionListViewModel())
    }
}
