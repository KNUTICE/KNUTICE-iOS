//
//  HomeScreenView.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/6/26.
//

import Combine
import ComposableArchitecture
import KNCore
import KNDeepLink
import KNDesignSystem
import KNDomain
import KNReadingRoom
import KNMeal
import KNNotice
import KNSetting
import KNTip
import KNUtility
import SwiftUI
import UIComponents
import FirebaseAnalytics

struct HomeScreenView: View {
    @State private var store: StoreOf<HomeScreenFeature>
    @State private var currentTabIndex: Int = 0
    @State private var timerSubscription: AnyCancellable?
    
    init(store: StoreOf<HomeScreenFeature>) {
        self.store = store
        
        UIPageControl.appearance().currentPageIndicatorTintColor = KNDesignSystemAsset.accent2.color
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.secondary)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TipBannerView(viewModel: TipBannerViewModel())
                
                HStack(spacing: 20) {
                    NavigationLink {
                        MealView()
                            .navigationTitle("학식 조회")
                            .background(KNDesignSystemAsset.primaryBackground.swiftUIColor)
                            .ignoresSafeArea(edges: .bottom)
                    } label: {
                        HomeCardView(title: "학식 조회") {
                            Image("icon_dining_menu")
                        }
                    }
                    
                    NavigationLink {
                        ReadingRoomStatusView()
                            .toolbar(.hidden, for: .navigationBar)
                            .background(KNDesignSystemAsset.primaryBackground.swiftUIColor)
                            .ignoresSafeArea(edges: .bottom)
                    } label: {
                        HomeCardView(title: "열람실 조회") {
                            Image("icon_study_area")
                        }
                    }
                }
                
                switch store.sectionedNotices {
                case let .loaded(sectionedNotices):
                    TabView(selection: $currentTabIndex) {
                        ForEach(Array(sectionedNotices.enumerated()), id: \.element.header) { index, section in
                            NoticeList(notices: section, bookmarkFormFactory: BookmarkFormFactoryImpl()) {
                                Button {
                                    NotificationCenter.default.post(
                                        name: .didReceiveDeepLink,
                                        object: DeepLink.navigation(tabIndex: 1, itemIndex: index)
                                    )
                                } label: {
                                    MoreButtonLabel()
                                }
                            }
                            .tag(index)
                        }
                    }
                    .padding(.top, -30)
                    .frame(minHeight: 340)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
                    }
                    .onChange(of: currentTabIndex) {
                        startTimer()
                    }
                    
                case .error:
                    ErrorStateView()
                    
                default:
                    EmptyView()
                }
                
                switch store.majorNotices {
                case let .loaded(majorNotices):
                    NoticeList(notices: majorNotices, bookmarkFormFactory: BookmarkFormFactoryImpl()) {
                        Button {
                            NotificationCenter.default.post(name: .didReceiveDeepLink, object: DeepLink.navigation(tabIndex: 1))
                        } label: {
                            MoreButtonLabel()
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
                    }
                    
                case .empty:
                    EmptyMajorNoticeView()
                    
                case .error:
                    ErrorStateView()
                    
                default:
                    EmptyView()
                }
                
            }
            .padding([.leading, .trailing, .bottom])
        }
        .background(KNDesignSystemAsset.primaryBackground.swiftUIColor)
        .onAppear {
            store.send(.onAppear)
            startTimer()
        }
        .refreshable {
            // 새로고침 중 상태 변화로 비동기 작업이 취소되지 않도록 별도 Task에서 실행
            await Task { await store.send(.fetchAllContents).finish() }.value
        }
        .toolbar(.visible)    // iPadOS에서 툴바 활성화를 위해서 적용
        .toolbar {
            // iPadOS 툴바 생성
            if UIDevice.current.userInterfaceIdiom == .pad {
                ToolbarItem(placement: .topBarLeading) {
                    Text("KNUTICE")
                        .bold()
                        .font(.title2)
                        .fixedSize()
                }
                .fork { view in
                    if #available(iOS 26.0, *) {
                        view.sharedBackgroundVisibility(.hidden)
                    } else {
                        view
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        timerSubscription?.cancel() // 기존 타이머 제거
        timerSubscription = Timer.publish(every: 7, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                handleTimerTick()
            }
    }
    
    private func handleTimerTick() {
        if case let .loaded(sectionedNotices) = store.sectionedNotices {
            let totalCount = sectionedNotices.count
            guard totalCount > 0 else { return }
            
            withAnimation {
                currentTabIndex = (currentTabIndex + 1) % totalCount
            }
        }
    }
}

fileprivate struct HomeCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let icon: () -> Image
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .bold()
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(colorScheme == .light ? .black : .white)
            
            icon()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 110)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding([.leading, .top])
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        }
    }
}

fileprivate struct NoticeList<Content: View>: View {
    @State private var isActivityViewPresented: Bool = false
    @State private var layoutType: ABTestLayoutType?
    @State private var isShowingBookmarkForm: Bool = false
    
    let notices: MainSectionNotice
    let bookmarkFormFactory: BookmarkFormFactory
    let moreButton: (() -> Content)?
    
    var body: some View {
        VStack {
            HStack {
                Text(notices.header)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle((notices.category as? NoticeCategory).map { titleColor(for: $0) } ?? .primary)
                    .redacted(reason: notices.items.first?.presentationType == .skeleton ? .placeholder : [])
                
                moreButton?()
            }
            
            ForEach(Array(notices.items.enumerated()), id: \.element.notice.id) { index, item in
                NavigationLink {
                    // 상세 화면 이동
                    NoticeContentView(notice: item.notice) { notice in bookmarkFormFactory.make(for: notice) }
                        .ignoresSafeArea(.all)
                        .toolbar {
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                if let layoutType, case .typeB = layoutType {
                                    Button {
                                        // Bookmark 버튼 클릭 이벤트 전송
                                        Analytics.logEvent(AnalyticsEventName.bookmarkButtonClicked.rawValue, parameters: nil)
                                        
                                        // Bookmark Form 표시
                                        isShowingBookmarkForm.toggle()
                                    } label: {
                                        Image(systemName: "bookmark")
                                    }
                                }
                                
                                Button {
                                    isActivityViewPresented.toggle()
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                        }
                        .background {
                            if let url = item.notice.contentUrl {
                                ActivityView(isPresented: $isActivityViewPresented, activityItems: [
                                    url
                                ])
                            }
                        }
                        .task {
                            await fetchLayoutType()
                        }
                        .sheet(isPresented: $isShowingBookmarkForm) {
                            NavigationStack {
                                let bookmark = Bookmark(notice: item.notice, memo: "")
                                
                                BookmarkForm(
                                    store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                                        BookmarkFormFeature()
                                    }
                                ) {
                                    isShowingBookmarkForm.toggle()
                                }
                            }
                        }
                } label: {
                    NoticeListRow(notice: item.notice)
                        .redacted(reason: item.presentationType == .skeleton ? .placeholder : [])
                }
                
                // 마지막 아이템이 아닐 때만 구분선 추가
                if index < notices.items.count - 1 {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.horizontal, 4)
                }
            }
        }
        .padding()
    }
    
    private func fetchLayoutType() async {
        let layout = await ABTestManager.shared.value(for: ABTestKeys.noticeDetailLayoutType)
        layoutType = ABTestLayoutType(rawValue: layout)
    }
    
    private func titleColor(for notice: NoticeCategory) -> Color {
        switch notice {
        case .generalNotice:
            return KNDesignSystemAsset.accentOrange.swiftUIColor
        case .academicNotice:
            return KNDesignSystemAsset.accentAmber.swiftUIColor
        case .scholarshipNotice:
            return KNDesignSystemAsset.accentMint.swiftUIColor
        case .eventNotice:
            return KNDesignSystemAsset.accentBlue.swiftUIColor
        case .employmentNotice:
            return KNDesignSystemAsset.accentPurple.swiftUIColor
        }
    }
    
}

fileprivate struct NoticeListRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notice.title)
                .font(.footnote)
                .bold()
                .lineLimit(1)
                .foregroundStyle(colorScheme == .light ? .black : .white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 5) {
                Text("[" + notice.department + "]")
                Text(notice.uploadDate)
            }
            .foregroundStyle(KNDesignSystemAsset.subTitle.swiftUIColor)
            .font(.caption)
            
        }
        .padding([.top, .bottom])
    }
}

fileprivate struct EmptyMajorNoticeView: View {
    var body: some View {
        VStack(spacing: 16) {
            // 아이콘 부분
            Image("graduation_cap")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding(.top, 20)
            
            // 안내 텍스트
            Text("학과를 선택하면 학과 소식을 받아 볼 수 있어요.")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // 학과 선택 버튼
            Button {
                NotificationCenter.default.post(name: .didReceiveDeepLink, object: DeepLink.navigation(tabIndex: 1))
            } label: {
                Text("학과 선택하기")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background {
                        Capsule()
                            .fill(KNDesignSystemAsset.accent2.swiftUIColor)
                    }
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        }
    }
}

fileprivate struct MoreButtonLabel: View {
    var body: some View {
        Text("더보기")
            .font(.subheadline)
            .foregroundStyle(.gray)
    }
}

fileprivate struct ErrorStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(KNDesignSystemAsset.gray3.swiftUIColor)
            
            VStack(spacing: 4) {
                Text("데이터를 불러올 수 없습니다")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text("일시적인 네트워크 오류이거나 점검 중일 수 있습니다.\n잠시 후 다시 시도해 주세요.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreenView(store: .init(initialState: HomeScreenFeature.State()) {
            HomeScreenFeature()
        })
    }
}
