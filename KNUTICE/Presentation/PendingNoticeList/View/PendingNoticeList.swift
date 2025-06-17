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
    @State private var isShowingFullScreenContent: Bool = false
    let notice: Notice
    
    var body: some View {
        VStack {
            if let category = notice.noticeCategory {
                CategoryBadge(category: category)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(notice.title)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 3)
            
            HStack {
                Text("[\(notice.department)]")
                
                Text(notice.uploadDate)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .foregroundStyle(.gray)
        }
        .padding()
        .onTapGesture {
            isShowingFullScreenContent.toggle()
        }
        .fullScreenCover(isPresented: $isShowingFullScreenContent) {
            NavigationStack {
                if #available(iOS 26, *) {
                    WebNoticeView()
                        .environment(WebNoticeViewModel(notice: notice))
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    isShowingFullScreenContent.toggle()
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                } else {
                    NoticeWebVCWrapper(notice: notice)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    isShowingFullScreenContent.toggle()
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                }
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

fileprivate struct CategoryBadge: View {
    let category: NoticeCategory
    
    var body: some View {
        Text(category.localizedDescription)
            .font(.caption2)
            .foregroundStyle(.white)
            .padding(8)
            .background(backgroundColor(for: category))
            .cornerRadius(20)
    }
    
    private func backgroundColor(for category: NoticeCategory) -> Color {
        switch category {
        case .generalNotice:
            return Color.salmon
        case .academicNotice:
            return Color.lightOrange
        case .scholarshipNotice:
            return Color.lightGreen
        case .eventNotice:
            return Color.dodgerBlue
        case .employmentNotice:
            return Color.orchid
        }
    }
}

#Preview {
    NavigationStack {
        PendingNoticeList()
            .environmentObject(PendingNoticeListViewModel())
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        PendingNoticeListRow(notice: Notice.generalNoticesSampleData[0])
    }
}
#endif
