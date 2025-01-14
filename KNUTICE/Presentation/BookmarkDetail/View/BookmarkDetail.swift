//
//  BookmarkDetail.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import SwiftUI

struct BookmarkDetail: View {
    @StateObject private var viewModel: BookmarkDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let bookmark: Bookmark
    
    init(viewModel: BookmarkDetailViewModel, bookmark: Bookmark) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.bookmark = bookmark
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                HeaderView(notice: bookmark.notice)
                    .padding()
                
                Divider()
                    .padding([.leading, .trailing])
                
                AlarmDetail(alarmDate: bookmark.alarmDate)
                    .padding()
                
                Divider()
                    .padding([.leading, .trailing])
                
                UserMemoDetail(userMemo: bookmark.memo)
                    .padding()
                
                Divider()
                    .padding([.leading, .trailing])
                
                NavigationLink {
                    NoticeWebVCWrapper(notice: bookmark.notice)
                        .edgesIgnoringSafeArea(.bottom)
                } label: {
                    Text("공지사항 이동")
                        .padding([.top, .bottom])
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(.accent2)
                        .cornerRadius(20)
                }
                .padding([.leading, .trailing])
                .padding(.top, 50)
            }
            .background(.customBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Button {
                                
                            } label: {
                                Text("수정")
                            }
                        }
                        
                        Section {
                            Button(role: .destructive) {
                                viewModel.delete(by: bookmark.notice.id)
                            } label: {
                                Text("삭제")
                                    .foregroundStyle(.red)
                            }
                        }
                    } label: {
                        Text("편집")
                    }
                }
            }
            
            if viewModel.isLoading {
                SpinningIndicator()
            }
        }
        .alert("알림", isPresented: $viewModel.isShowingAlert) {
            Button {
                viewModel.sendRefreshNotification()
                dismiss()
            } label: {
                Text("확인")
            }
        } message: {
            if let message = viewModel.alertMessage {
                Text(message)
            }
        }
    }
}

fileprivate struct HeaderView: View {
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notice.title)
                .bold()
                .font(.headline)
            
            HStack {
                Text(notice.department)
                
                Divider()
                
                Text(notice.uploadDate)
                
                Spacer()
            }
            .font(.caption)
            .foregroundStyle(.gray)
        }
    }
}

fileprivate struct AlarmDetail: View {
    let alarmDate: Date?
    
    var body: some View {
        HStack {
            Text("알림")
            
            Spacer()
            
            Text(alarmDate?.dateTime ?? "없음")
        }
        .font(.subheadline)
    }
}

fileprivate struct UserMemoDetail: View {
    let userMemo: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("메모")
                .padding(.bottom)
            
            Text(userMemo)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        BookmarkDetail(viewModel: AppDI.shared.makeBookmarkDetailViewModel(),
                       bookmark: Bookmark.sample)
    }
}
