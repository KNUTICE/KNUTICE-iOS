//
//  BookmarkForm.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import SwiftUI

struct BookmarkForm: View {
    enum FormType {
        case create
        case update
    }
    
    @EnvironmentObject private var viewModel: BookmarkFormViewModel
    
    private let formType: FormType
    private let dismissAction: () -> Void
    
    init(for formType: FormType, dismissAction: @escaping () -> Void) {
        self.formType = formType
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                NoticeHeader(notice: viewModel.bookmark.notice)
                
                AlarmPickerContainerView(
                    isAlarmOn: Binding(
                        get: {
                            return viewModel.isAlarmOn
                        },
                        set: {
                            if $0 {
                                viewModel.bookmark.alarmDate = Date()
                            } else {
                                viewModel.bookmark.alarmDate = nil
                            }
                            
                            viewModel.isAlarmOn = $0
                        }
                    ),
                    alarmDate: Binding(
                        get: {
                            return viewModel.bookmark.alarmDate ?? Date()
                        },
                        set: {
                            viewModel.bookmark.alarmDate = $0
                        }
                    )
                )
                
                TextFieldContainerView(memo: $viewModel.bookmark.memo)
            }
            .animation(.easeInOut, value: viewModel.isAlarmOn)
            .navigationTitle("북마크")
            .navigationBarTitleDisplayMode(.inline)
            .background(.primaryBackground)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismissAction()
                    } label: {
                        Text("취소")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {                    
                    Button {
                        switch formType {
                        case .create:
                            viewModel.save()
                        case .update:
                            viewModel.update()
                        }
                    } label: {
                        Text("저장")
                    }
                    .foregroundStyle(.accent2)
                }
            }
            .background(.detailViewBackground)
            
            if viewModel.isLoading {
                SpinningIndicator()
            }
        }
        .alert("알림", isPresented: $viewModel.isShowingAlert) {
            Button {
                if formType == .create {
                    viewModel.sendRefreshNotification()
                } else {
                    viewModel.sendReloadNotification()
                }
                
                dismissAction()
            } label: {
                Text("확인")
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

fileprivate struct AlarmPickerContainerView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isAlarmOn: Bool
    @Binding var alarmDate: Date
    
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
                    selection: $alarmDate,
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
        BookmarkForm(for: .create, dismissAction: {})
            .environmentObject(BookmarkFormViewModel(bookmark: Bookmark.sample))
    }
}
#endif
