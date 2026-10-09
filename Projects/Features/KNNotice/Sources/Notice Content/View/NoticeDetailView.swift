//
//  NoticeDetailView.swift
//  KNNotice
//
//  Created by 이정훈 on 6/9/26.
//

import CorePresentation
import FirebaseAnalytics
import KNDomain
import KNUtility
import SwiftUI

/// A SwiftUI wrapper view that displays the detailed content of a notice along with conditional toolbar actions.
///
/// `NoticeDetailView` acts as a host for `NoticeContentView` (a `UIViewControllerRepresentable` wrapper)
/// and ensures that SwiftUI native components like toolbars, sheets, and background activity views
/// render correctly.
///
/// ### Toolbar Visibility Issue Resolved
/// When using a `UIViewControllerRepresentable` directly inside a navigation hierarchy, the UIKit lifestyle
/// can sometimes intercept or improperly propagate navigation item updates, causing the SwiftUI `.toolbar`
/// to become invisible or fail to render.
///
/// To resolve this, `NoticeDetailView` serves as a dedicated SwiftUI-native container. By attaching the
/// `.toolbar`, `.sheet`, and `.background` modifiers directly to this SwiftUI view rather than inside the
/// UIKit representation, it guarantees that the trailing bar button items (Bookmark and Share) are reliably
/// managed and displayed by the SwiftUI environment.
///
/// ### A/B Testing Integration
/// This view dynamically adapts its toolbar layout based on an asynchronous remote A/B test configuration
/// (`ABTestLayoutType`). The bookmark feature is conditionally exposed only to users bucketed into `.typeB`.
public struct NoticeDetailView<Factory: BookmarkFormFactory>: View {
    @State private var layoutType: ABTestLayoutType?
    @State private var isShowingBookmarkForm: Bool = false
    @State private var isActivityViewPresented: Bool = false
    
    private let notice: Notice
    private let bookmarkFormFactory: Factory
    
    public init(notice: Notice, bookmarkFormFactory: Factory) {
        self.notice = notice
        self.bookmarkFormFactory = bookmarkFormFactory
    }
    
    public var body: some View {
        NoticeContentView(notice: notice) { notice in bookmarkFormFactory.make(for: notice) }
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
                if let url = notice.contentURL {
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
                    bookmarkFormFactory.makeSwiftUIView(for: notice) { isShowingBookmarkForm.toggle() }
                }
            }
    }
    
    private func fetchLayoutType() async {
        let layout = await ABTestManager.shared.value(for: ABTestKeys.noticeDetailLayoutType)
        layoutType = ABTestLayoutType(rawValue: layout)
    }
}

#if DEBUG
#Preview {
    NoticeDetailView(notice: Notice.generalNoticesSample.first!, bookmarkFormFactory: MockBookamrkFormFactory())
}
#endif
