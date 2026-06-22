//
//  BookmarkDetail.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import ComposableArchitecture
import CorePresentation
import KNDesignSystem
import KNDomain
import KNNotice
import SwiftUI

struct BookmarkDetail: View {
    @Bindable var store: StoreOf<BookmarkDetailFeature>
    @Environment(\.dismiss) private var dismiss
    
    let dismissAction: () -> Void
    
    var body: some View {
        Group {
            if let bookmark = store.bookmark {
                ZStack {
                    ScrollView {
                        NoticeHeader(notice: bookmark.notice)
                        
                        AlarmDetail(alarmDate: bookmark.alarmDate)
                        
                        UserMemoDetail(userMemo: bookmark.memo)
                        
                        Button {
                            store.send(.toggleWebView(true))
                        } label: {
                            Text("공지사항 이동")
                                .padding([.top, .bottom])
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .background(KNDesignSystemAsset.accent2.swiftUIColor)
                                .cornerRadius(20)
                        }
                        .padding([.top, .leading, .trailing])
                    }
                    .background(KNDesignSystemAsset.primaryBackground.swiftUIColor)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Section {
                                    Button {
                                        store.send(.editButtonTapped)
                                    } label: {
                                        Text("수정")
                                    }
                                }
                                
                                Section {
                                    Button(role: .destructive) {
                                        store.send(.deleteButtonTapped)
                                    } label: {
                                        Text("삭제")
                                            .foregroundStyle(.red)
                                    }
                                }
                            } label: {
                                Text("편집")
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $store.isShowingWebView) {
                        NavigationStack {
                            NoticeContentView(notice: bookmark.notice) { notice in
                                let bookmark = Bookmark(notice: notice, memo: "")
                                let bookmarkForm = BookmarkForm(
                                    store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                                        BookmarkFormFeature()
                                    }
                                ) { self.dismiss() }
                                
                                return UIHostingController(rootView: bookmarkForm)
                            }
                            .edgesIgnoringSafeArea(.bottom)
                            .background(KNDesignSystemAsset.detailViewBackground.swiftUIColor)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        store.send(.toggleWebView(false))
                                    } label: {
                                        Image(systemName: "xmark")
                                    }
                                }
                            }
                        }
                    }
                    .alert($store.scope(state: \.alert, action: \.alert))
                    .onChange(of: store.shouldDismiss) {
                        if store.shouldDismiss { dismissAction() }
                    }
                }
            } else {
                SpinningIndicator()
            }
        }
        .onAppear { store.send(.onAppear) }
        .onDisappear {
            if store.bookmark == nil {
                store.send(.onDisappear)
            }
        }
    }
}

fileprivate struct AlarmDetail: View {
    @Environment(\.colorScheme) private var colorScheme
    let alarmDate: Date?
    
    var body: some View {
        HStack {
            Text("미리 알림")
                .bold()
            
            Spacer()
            
            Text(alarmDate?.dateTime ?? "없음")
        }
        .font(.subheadline)
        .padding()
        .background(colorScheme == .light ? .white : KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        .cornerRadius(20)
        .padding()
    }
}

fileprivate struct UserMemoDetail: View {
    @Environment(\.colorScheme) private var colorScheme
    let userMemo: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("메모")
                .bold()
                .padding(.bottom)
            
            Text(userMemo)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(colorScheme == .light ? .white : KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        .cornerRadius(20)
        .padding()
    }
}

#if DEBUG
#Preview {
    var bookmarkDetailStore: StoreOf<BookmarkDetailFeature> {
        Store(
            initialState: BookmarkDetailFeature.State(
                bookmark: Bookmark.sample,
                nttId: Bookmark.sample.identity
            ),
            reducer: {
                BookmarkDetailFeature()
            }
        )
    }
    
    NavigationStack {
        BookmarkDetail(store: bookmarkDetailStore) {
            // Something to do
        }
    }
}
#endif
