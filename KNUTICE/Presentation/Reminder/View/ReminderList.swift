//
//  ReminderList.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import SwiftUI

struct ReminderList: View {
    @StateObject private var viewModel: ReminderListViewModel
    
    init(viewModel: ReminderListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
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
                ReminderSectionHeader(title: "리마인드", count: viewModel.uncompletedReminders.count)
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
