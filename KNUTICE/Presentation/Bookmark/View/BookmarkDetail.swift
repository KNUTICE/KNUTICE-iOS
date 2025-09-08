//
//  BookmarkDetail.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import KNUTICECore
import SwiftUI

struct BookmarkDetail: View {
    @EnvironmentObject private var viewModel: BookmarkViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingWebView: Bool = false
    @Binding private var selectedMode: BookmarkDetailSwitchView.BookmarkViewMode
    
    init(selectedMode: Binding<BookmarkDetailSwitchView.BookmarkViewMode>) {
        _selectedMode = selectedMode
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                NoticeHeader(notice: viewModel.bookmark.notice)
                
                AlarmDetail(alarmDate: viewModel.bookmark.alarmDate)
                
                UserMemoDetail(userMemo: viewModel.bookmark.memo)
                
                Button {
                    isShowingWebView = true
                } label: {
                    Text("공지사항 이동")
                        .padding([.top, .bottom])
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(.accent2)
                        .cornerRadius(20)
                }
                .padding([.leading, .trailing])
                .padding(.top)
            }
            .background(.primaryBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Button {
                                withAnimation(.easeInOut) {
                                    selectedMode = .editView
                                }
                            } label: {
                                Text("수정")
                            }
                        }
                        
                        Section {
                            Button(role: .destructive) {
                                viewModel.delete()
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
            .fullScreenCover(isPresented: $isShowingWebView) {
                NavigationStack {
                    NoticeWebVCWrapper(notice: viewModel.bookmark.notice)
                        .edgesIgnoringSafeArea(.bottom)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    isShowingWebView = false
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                        .background(.detailViewBackground)
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
            Text(viewModel.alertMessage)
        }
        .onDisappear {
            viewModel.saveTask?.cancel()
            viewModel.deleteTask?.cancel()
            viewModel.updateTask?.cancel()
        }
    }
}

fileprivate struct AlarmDetail: View {
    @Environment(\.colorScheme) private var colorScheme
    let alarmDate: Date?
    
    var body: some View {
        HStack {
            Text("미리 알림")
                .bold()
            
            Spacer()
            
            Text(alarmDate?.dateTime ?? "없음")
        }
        .font(.subheadline)
        .padding()
        .background(colorScheme == .light ? .white : .mainCellBackground)
        .cornerRadius(20)
        .padding()
    }
}

fileprivate struct UserMemoDetail: View {
    @Environment(\.colorScheme) private var colorScheme
    let userMemo: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("메모")
                .bold()
                .padding(.bottom)
            
            Text(userMemo)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(colorScheme == .light ? .white : .mainCellBackground)
        .cornerRadius(20)
        .padding()
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        BookmarkDetail(selectedMode: .constant(.detailView))
            .environmentObject(BookmarkViewModel(bookmark: Bookmark.sample))
    }
}
#endif
