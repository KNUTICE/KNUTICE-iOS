//
//  ReminderForm.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/25.
//

import SwiftUI

struct ReminderForm: View {
    @StateObject private var viewModel: ReminderFormViewModel
    @Binding private var isShowingSheet: Bool
    
    private let url: String
    private let dismissAction: () -> Void
    
    init(viewModel: ReminderFormViewModel,
         isShowingSheet: Binding<Bool>,
         url: String,
         dismissAction: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isShowingSheet = isShowingSheet
        self.url = url
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: -5) {
                SectionHeader(title: "제목")
                
                StrokedTextField(text: $viewModel.title)
            }
            
            VStack(spacing: -5) {
                SectionHeader(title: "날짜")
                
                StrokedDatePicker(date: $viewModel.date)
            }
            
            VStack(spacing: -5) {
                SectionHeader(title: "미리알림")
                
                StrokedAdvanceNoticePicker(isAlarmOn: $viewModel.isAlarmOn,
                                           reminderTimeOffset: $viewModel.reminderTimeOffset)
            }
            
            VStack(spacing: -5) {
                SectionHeader(title: "메모")
                
                StrokedDescriptionTextField(description: $viewModel.content)
            }
        }
        .animation(.easeInOut, value: viewModel.isAlarmOn)
        .navigationTitle("새로운 작업")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismissAction()
                    isShowingSheet.toggle()
                } label: {
                    Text("취소")
                        .accentColor(.accent2)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("저장")
                }
                .disabled(true)
            }
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

fileprivate struct StrokedTextField: View {
    @Binding var text: String
    
    var body: some View {
        TextField("제목입력", text: $text)
            .font(.subheadline)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 0.4)
            )
            .padding([.leading, .bottom, .trailing])
    }
}

fileprivate struct StrokedDatePicker: View {
    @Binding var date: Date
    
    var body: some View {
        DatePicker(
            "마감 날짜 선택",
            selection: $date,
            displayedComponents: [.date, .hourAndMinute]
        )
        .font(.subheadline)
        .accentColor(.accent2)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 0.4)
        }
        .padding([.leading, .bottom, .trailing])
        
    }
}

fileprivate struct StrokedAdvanceNoticePicker: View {
    @Binding var isAlarmOn: Bool
    @Binding var reminderTimeOffset: ReminderTimeOffset
    
    var body: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $isAlarmOn) {
                Text("마감 전 미리알림")
            }
            .tint(.accent2)
            .font(.subheadline)
            .padding()
            
            if isAlarmOn {
                Divider()
                    .padding([.leading, .trailing])
                
                Picker("", selection: $reminderTimeOffset) {
                    ForEach(ReminderTimeOffset.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.wheel)
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

#Preview {
    NavigationStack {
        ReminderForm(viewModel: AppDI.shared.makeReminderFormViewModel(),
                     isShowingSheet: .constant(true),
                     url: "",
                     dismissAction: {})
    }
}
