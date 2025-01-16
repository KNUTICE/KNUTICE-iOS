//
//  BookmarkForm.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import SwiftUI

struct BookmarkForm<T: BookmarkFormHandler>: View {
    @StateObject private var viewModel: T
    
    private let notice: Notice
    private let dismissAction: () -> Void
    
    init(viewModel: T,
         notice: Notice,
         dismissAction: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.notice = notice
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                NoticeView(notice: notice)
                
                Rectangle()
                    .fill(.mainBackground)
                    .frame(height: 8)
                
                VStack(spacing: -5) {
                    SectionHeader(title: "알림 반복")
                    
                    StrokedAdvanceNoticePicker(isAlarmOn: $viewModel.isAlarmOn,
                                               alarmDate: $viewModel.alarmDate)
                }
                
                VStack(spacing: -5) {
                    SectionHeader(title: "메모")
                    
                    StrokedDescriptionTextField(description: $viewModel.memo)
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
                        Text("취소")
                            .accentColor(.accent2)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.save(with: notice)
                    } label: {
                        Text("저장")
                            .accentColor(.accent2)
                    }
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

fileprivate struct StrokedDescriptionTextField: View {
    @Binding var description: String
    
    var body: some View {
        TextField("Description", text: $description, axis: .vertical)
            .lineLimit(5...10)
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
        BookmarkForm(viewModel: AppDI.shared.makeBookmarkFormViewModel(),
                     notice: Notice.generalNoticesSampleData.first!,
                     dismissAction: {})
    }
}
#endif
