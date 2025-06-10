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
                NoticeView(notice: viewModel.bookmark.notice)
                
                Rectangle()
                    .fill(.mainBackground)
                    .frame(height: 8)
                
                VStack(spacing: -5) {
                    SectionHeader(title: "알림 반복")
                    
                    StrokedAdvanceNoticePicker(
                        isAlarmOn: Binding(
                            get: {
                                return viewModel.isAlarmOn
                            }, set: {
                                if $0 {
                                    viewModel.bookmark.alarmDate = Date()
                                } else {
                                    viewModel.bookmark.alarmDate = nil
                                }
                                
                                viewModel.isAlarmOn = $0
                            }),
                        alarmDate: Binding(
                            get: {
                                return viewModel.bookmark.alarmDate ?? Date()
                            },
                            set: {
                                viewModel.bookmark.alarmDate = $0
                            }
                        )
                    )
                }
                
                VStack(spacing: -5) {
                    SectionHeader(title: "메모")
                    
                    BorderedDescriptionTextField(description: $viewModel.bookmark.memo)
                }
            }
            .animation(.easeInOut, value: viewModel.isAlarmOn)
            .navigationTitle("북마크")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismissAction()
                    } label: {
                        if #available(iOS 26, *) {
                            Image(systemName: "xmark")
                        } else {
                            Text("취소")
                                .accentColor(.accent2)
                        }
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
                        if #available(iOS 26, *) {
                            Image(systemName: "checkmark")
                        } else {
                            Text("저장")
                        }
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
                viewModel.sendRefreshNotification()
                dismissAction()
            } label: {
                Text("확인")
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

fileprivate struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.footnote)
            
            Spacer()
        }
        .bold()
        .padding()
    }
}

fileprivate struct NoticeView: View {
    let notice: Notice
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .frame(width: 5)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(notice.title)
                        .font(.subheadline)
                    
                    HStack {
                        Text("[\(notice.department)]")
                        
                        Text(notice.uploadDate)
                    }
                    .font(.caption2)
                    .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}

fileprivate struct StrokedAdvanceNoticePicker: View {
    @Binding var isAlarmOn: Bool
    @Binding var alarmDate: Date
    
    var body: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $isAlarmOn) {
                Text("다시 알림 받기")
            }
            .tint(.accent2)
            .font(.subheadline)
            .padding()
            
            if isAlarmOn {
                Divider()
                    .padding([.leading, .trailing])
                
                DatePicker(
                    "알림 시간",
                    selection: $alarmDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .font(.subheadline)
                .accentColor(.accent2)
                .padding()
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, style: StrokeStyle(lineWidth: 0.4))
        }
        .padding([.leading, .bottom, .trailing])
    }
}

fileprivate struct BorderedDescriptionTextField: View {
    @Binding var description: String
    
    var body: some View {
        TextField("중요한 메모는 여기에 작성하세요.", text: $description, axis: .vertical)
            .lineLimit(10...10)
            .font(.subheadline)
            .accentColor(.accentColor)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, style: StrokeStyle(lineWidth: 0.4))
            }
            .padding([.leading, .bottom, .trailing])
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
