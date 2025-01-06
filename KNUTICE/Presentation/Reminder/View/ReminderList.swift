//
//  ReminderList.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import SwiftUI

struct ReminderList: View {
    @StateObject private var viewModel: ReminderListViewModel
    @State private var isShowingSheet: Bool = false
    
    init(viewModel: ReminderListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                Section {
                    if !viewModel.uncompletedReminders.isEmpty {
                        ForEach(0..<viewModel.uncompletedReminders.count, id: \.self) { idx in
                            NavigationLink {
                                
                            } label: {
                                ReminderRow(reminder: $viewModel.uncompletedReminders[idx])
                            }
                        }
                    } else {
                        EmptyReminderSection(content: "완료할 항목이 없어요 :(")
                    }
                } header: {
                    ReminderSectionHeader(title: "작업", count: viewModel.uncompletedReminders.count)
                }
                
                
                Section {
                    if !viewModel.completedReminders.isEmpty {
                        ForEach(0..<viewModel.completedReminders.count, id: \.self) { idx in
                            NavigationLink {
                                
                            } label: {
                                ReminderRow(reminder: $viewModel.completedReminders[idx])
                            }
                        }
                    } else {
                        EmptyReminderSection(content: "완료된 항목이 없어요 :(")
                    }
                } header: {
                    ReminderSectionHeader(title: "완료됨", count: viewModel.completedReminders.count)
                }
                .padding(.top)
            }
            .padding()
            .background(.mainBackground)
            
            Circle()
                .fill(.accent2)
                .frame(width: 50)
                .overlay {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 30)
                .padding(.trailing, 20)
                .shadow(radius: 7)
                .onTapGesture {
                    isShowingSheet.toggle()
                }
        }
        .sheet(isPresented: $isShowingSheet) {
            NavigationStack {
                ReminderForm(viewModel: AppDI.shared.makeReminderFormViewModel(),
                             isShowingSheet: $isShowingSheet, url: "") {}
            }
        }
    }
}

fileprivate struct ReminderSectionHeader: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack {
            Text("\(title) \(count)")
                .bold()
                .foregroundStyle(.gray)
            
            Spacer()
        }
    }
}

fileprivate struct EmptyReminderSection: View {
    let content: String
    
    var body: some View {
        Text(content)
            .foregroundStyle(.gray)
            .frame(height: 200)
    }
}

#Preview {
    NavigationStack {
        ReminderList(viewModel: ReminderListViewModel())
    }
}
