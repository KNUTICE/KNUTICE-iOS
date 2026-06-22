//
//  NotificationSubscriptionList.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import ComposableArchitecture
import CorePresentation
import KNDesignSystem
import KNDomain
import SwiftUI

public struct TopicSubscriptionList: View {
    @Bindable var store: StoreOf<TopicSubscriptionListFeature>
    @Environment(\.dismiss) private var dismiss
    
    public init(store: StoreOf<TopicSubscriptionListFeature>) {
        self.store = store
    }
    
    public var body: some View {
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
                    Toggle(isOn: Binding(
                        get: { store.isMajorNoticeNotificationSubscribed },
                        set: { store.send(.toggleMajor($0)) })
                    ) {
                        ToggleCaption(
                            title: "학과소식",
                            caption: """
                                    각 학과의 최신 소식을 알려드려요.
                                    알림 받을 학과를 변경하려면 두 번째 탭에서 원하는 학과를 선택해주세요.
                                    """
                        )
                    }
                    .tint(KNDesignSystemAsset.accent2.swiftUIColor)
                }
                
                Section {
                    Toggle(isOn: Binding(
                        get: { store.isStudentCafeteriaNotificationSubscribed },
                        set: { store.send(.toggleCafeteria(.studentCafeteria, $0)) })
                    ) {
                        ToggleCaption(
                            title: "학생 식당",
                            caption: "학생 식당의 메뉴를 알려드려요."
                        )
                    }
                    
                    Toggle(isOn: Binding(
                        get: { store.isStaffCafeteriaNotificationSubscribed },
                        set: { store.send(.toggleCafeteria(.staffCafeteria, $0)) })
                    ) {
                        ToggleCaption(
                            title: "교직원 식당",
                            caption: "교직원 식당의 메뉴를 알려드려요."
                        )
                    }
                }
                .tint(KNDesignSystemAsset.accent2.swiftUIColor)
            }
            
            SpinningIndicator()
                .opacity(store.isLoading ? 1 : 0)
        }
        .navigationTitle("서비스 알림")
        .navigationBarTitleDisplayMode(.inline)
        .task { await store.send(.onAppear).finish() }
        .onDisappear { store.send(.onDisappear) }
        .alert($store.scope(state: \.alert, action: \.alert))
        .alert($store.scope(state: \.fcmTokenErrorAlert, action: \.fcmTokenErrorAlert))
    }
    
    private func toggleRow(
        title: String,
        caption: String,
        topic: NoticeCategory
    ) -> some View {
        Toggle(
            isOn: Binding(
                get: { store.noticeSubscriptionStates[topic, default: false] },
                set: { store.send(.toggleNotice(topic, $0)) }
            )
        ) {
            ToggleCaption(title: title, caption: caption)
        }
        .tint(KNDesignSystemAsset.accent2.swiftUIColor)
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
