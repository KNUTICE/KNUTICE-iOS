//
//  PendingNoticeList.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/16/25.
//

import SwiftUI

struct PendingNoticeList: View {
    @EnvironmentObject private var viewModel: PendingNoticeListViewModel
    
    var body: some View {
        Group {
            if let notices = viewModel.notices {
                ZStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(notices, id: \.id) { notice in
                                PendingNoticeListRow(notice: notice)
                            }
                        }
                    }
                    
                    EmptyPendingNoticeView()
                        .opacity(notices.isEmpty ? 1 : 0)
                }
            } else  {
                SpinningIndicator()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("알림")
        .task {
            await viewModel.fetch()
        }
    }
}

fileprivate struct PendingNoticeListRow: View {
    let notice: Notice
    
    var body: some View {
        NavigationLink {
            
        } label: {
            HStack {
                Image(systemName: "bell")
                
                Text(notice.title)
            }
        }
    }
}

fileprivate struct EmptyPendingNoticeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("bell")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            Text("알림 내역이 없어요")
                .foregroundStyle(.gray)
                .bold()
        }
        .offset(y: -44)
    }
}

#Preview {
    NavigationStack {
        PendingNoticeList()
            .environmentObject(PendingNoticeListViewModel())
    }
}
