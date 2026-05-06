//
//  BookmarkForm.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import ComposableArchitecture
import KNDesignSystem
import KNDomain
import SwiftUI

public struct BookmarkForm: View {
    @Bindable private var store: StoreOf<BookmarkFormFeature>
    private let dismissAction: () -> Void
    
    public init(store: StoreOf<BookmarkFormFeature>, dismissAction: @escaping () -> Void) {
        _store = Bindable(store)
        self.dismissAction = dismissAction
    }
    
    public var body: some View {
        ScrollView {
            NoticeHeader(notice: store.bookmark.notice)
            
            AlarmPickerContainerView(
                isAlarmOn: $store.isAlarmOn,
                alarmDate: $store.bookmark.alarmDate
            )
            
            TextFieldContainerView(memo: $store.bookmark.memo)
        }
        .navigationTitle("북마크")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .background(KNDesignSystemAsset.primaryBackground.swiftUIColor)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.cancelButtonTapped)
                } label: {
                    Text("취소")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.saveButtonTapped)
                } label: {
                    Text("저장")
                }
                .foregroundStyle(KNDesignSystemAsset.accent2.swiftUIColor)
            }
        }
        .background(KNDesignSystemAsset.detailViewBackground.swiftUIColor)
        .animation(.easeInOut, value: store.state.isAlarmOn)
        .alert($store.scope(state: \.alert, action: \.alert))
        .onChange(of: store.shouldDismiss) {
            if store.shouldDismiss { dismissAction() }
        }
    }
}

fileprivate struct AlarmPickerContainerView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isAlarmOn: Bool
    @Binding var alarmDate: Date?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("미리 알림")
                .bold()
                .padding(.bottom)
            
            Toggle(isOn: $isAlarmOn) {
                Text("다시 알림 받기")
            }
            .tint(KNDesignSystemAsset.accent2.swiftUIColor)
            .font(.subheadline)
            
            if isAlarmOn {
                Divider()
                    .padding([.top, .bottom])
                
                DatePicker(
                    "알림 시간",
                    selection: Binding(
                        get: { alarmDate ?? Date() },
                        set: { alarmDate = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .font(.subheadline)
                .accentColor(KNDesignSystemAsset.accent2.swiftUIColor)
            }
        }
        .padding()
        .background(colorScheme == .light ? .white : KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        .cornerRadius(20)
        .padding()
    }
    
}

fileprivate struct TextFieldContainerView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var memo: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("메모")
                .bold()
                .padding(.bottom)
            
            TextField("중요한 메모는 여기에 작성하세요.", text: $memo, axis: .vertical)
                .lineLimit(10...10)
                .font(.subheadline)
                .accentColor(.accentColor)
        }
        .padding()
        .background(colorScheme == .light ? .white : KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        .cornerRadius(20)
        .padding()
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        BookmarkForm(
            store: Store(
                initialState: BookmarkFormFeature.State(
                    bookmark: Bookmark.sample,
                    original: Bookmark.sample,
                    formType: .create
                )
            ) {
                BookmarkFormFeature()
            }
        ) {
            // Dismiss Action
        }
    }
}
#endif

