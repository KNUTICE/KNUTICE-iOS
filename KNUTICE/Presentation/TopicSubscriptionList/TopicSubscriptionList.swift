//
//  NotificationSubscriptionList.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import ComposableArchitecture
import SwiftUI
import KNUTICECore

struct TopicSubscriptionList: View {
    let store: StoreOf<TopicSubscriptionListFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                List {
                    Section {
                        toggleRow(
                            title: "일반소식",
                            caption: "학교의 주요 공지와 관련된 다양한 소식을 알려드려요.",
                            topic: .generalNotice
                        )
                        
                        toggleRow(
                            title: "학사공지",
                            caption: "수강, 성적, 졸업 등 학사 운영과 관련된 다양한 소식을 알려드려요.",
                            topic: .academicNotice
                        )
                        
                        toggleRow(
                            title: "장학안내",
                            caption: "장학금의 신청 자격, 절차, 일정 등과 관련된 다양한 소식을 알려드려요.",
                            topic: .scholarshipNotice
                        )
                        
                        toggleRow(
                            title: "행사안내",
                            caption: "학교에서 진행되는 각종 교육, 문화, 진로와 관련된 다양한 소식을 알려드려요.",
                            topic: .eventNotice
                        )
                        
                        toggleRow(
                            title: "취업안내",
                            caption: "채용 정보, 취업 지원 프로그램, 진로 상담 등 학생들의 진로 설계를 돕기 위한 소식을 알려드려요.",
                            topic: .employmentNotice
                        )
                    }
                    
                    Section {
                        Toggle(
                            isOn: ViewStore(store, observe: { $0 }).binding(
                                get: { $0.isMajorNoticeNotificationSubscribed },
                                send: { .toggleMajor($0) }
                            )
                        ) {
                            ToggleCaption(
                                title: "학과소식",
                                caption: """
                                    각 학과의 최신 소식을 알려드려요.
                                    알림 받을 학과를 변경하려면 두 번째 탭에서 원하는 학과를 선택해주세요.
                                    """
                            )
                        }
                        .tint(.accent2)
                    }
                }
                
                if viewStore.isLoading {
                    SpinningIndicator()
                }
            }
            .navigationTitle("서비스 알림")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await store.send(.onAppear).finish()
            }
            .onDisappear {
                store.send(.onDisappear)
            }
            .alert("알림 상태를 변경할 수 없어요.",
                   isPresented: ViewStore(store, observe: { $0 }).binding(
                    get: { $0.isShowingAlert },
                    send: { _ in .showAlert("") }
                   )
            ) {
                Button("확인") { }
            } message: {
                Text(viewStore.alertMessage)
            }
            .alert("알림",
                   isPresented: ViewStore(store, observe: { $0 }).binding(
                    get: { $0.isShowingFCMTokenErrorAlert },
                    send: { _ in .showFCMTokenErrorAlert(false) }
                   )
            ) {
                Button("확인") {
                    dismiss()
                }
            } message: {
                Text("현재 서비스를 이용할 수 없습니다.\n잠시 후에 다시 시도해 주세요.")
            }
        }
    }
    
    private func toggleRow(
        title: String,
        caption: String,
        topic: NoticeCategory
    ) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Toggle(
                isOn: viewStore.binding(
                    get: { $0.noticeSubscriptionStates[topic, default: false] },
                    send: { .toggleNotice(topic, $0) }
                )
            ) {
                ToggleCaption(title: title, caption: caption)
            }
            .tint(.accent2)
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
        TopicSubscriptionList(
            store: Store(initialState: TopicSubscriptionListFeature.State()) {
                TopicSubscriptionListFeature()
            }
        )
    }
}
