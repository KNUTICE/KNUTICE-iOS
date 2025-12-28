//
//  BookmarkForm.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import ComposableArchitecture
import KNUTICECore
import SwiftUI

struct BookmarkForm: View {
    @Perception.Bindable var store: StoreOf<BookmarkFormFeature>
    let dismissAction: () -> Void
    
    var body: some View {
        WithPerceptionTracking {
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
            .background(.primaryBackground)
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
                    .foregroundStyle(.accent2)
                }
            }
            .background(.detailViewBackground)
            .animation(.easeInOut, value: store.state.isAlarmOn)
            .alert($store.scope(state: \.alert, action: \.alert))
            .onChange(of: store.shouldDismiss) { shouldDismiss in
                if shouldDismiss { dismissAction() }
            }
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
            .tint(.accent2)
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
                .accentColor(.accent2)
            }
        }
        .padding()
        .background(colorScheme == .light ? .white : .mainCellBackground)
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
        .background(colorScheme == .light ? .white : .mainCellBackground)
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
