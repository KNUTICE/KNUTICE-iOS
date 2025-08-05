//
//  TipBannerView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import SwiftUI

struct TipBannerView: View, EntryTimeRecordable {
    @EnvironmentObject private var viewModel: TipBannerViewModel
    @State private var isShowingFullScreen: Bool = false
    
    var body: some View {
        if let tips = viewModel.tips {
            ZStack {
                Color.primaryBackground
                    .ignoresSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.mainCellBackground)
                    .frame(height: 40)
                    .padding(16)

                ZStack {
                    ForEach([viewModel.selectedIndex], id: \.self) { index in
                        TipItemView(content: tips[index].title)
                            .transition(.push(from: .top))
                            .padding([.leading, .trailing], 30)
                    }
                }
                .animation(.easeInOut(duration: 0.8), value: viewModel.selectedIndex)
            }
            .onAppear {
                viewModel.startAutoScrollTimer()
            }
            .onDisappear {
                viewModel.task?.cancel()
            }
            .onTapGesture {
                viewModel.selectedURL = tips[viewModel.selectedIndex].contentURL
                isShowingFullScreen.toggle()
            }
            .fullScreenCover(isPresented: $isShowingFullScreen) {
                NavigationStack {
                    BaseWebView(
                        progress: .constant(0),
                        isLoading: .constant(false),
                        url: viewModel.selectedURL
                    )
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                isShowingFullScreen.toggle()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    }
                }
            }
            .onReceive(foregroundPublisher) { _ in
                if timeIntervalSinceLastEntry() >= 1800 {
                    recordEntryTime()
                    
                    Task {
                        await viewModel.fetchTips()
                    }
                }
            }
        } else {
            Color.clear
                .task {
                    await viewModel.fetchTips()
                }
        }
    }
}

fileprivate struct TipItemView: View {
    let content: String
    
    var body: some View {
        Text(content)
            .font(.caption)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        TipBannerView()
            .environmentObject(TipBannerViewModel())
    }
}
