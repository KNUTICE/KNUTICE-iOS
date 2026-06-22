//
//  TipBannerView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import CorePresentation
import KNDesignSystem
import KNDomain
import KNUtility
import SwiftUI

public struct TipBannerView: View, EntryTimeRecordable {
    @StateObject private var viewModel: TipBannerViewModel
    @State private var isShowingFullScreen: Bool = false
    
    public init(viewModel: TipBannerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        if let tips = viewModel.tips {
            ZStack {
                ForEach([viewModel.selectedIndex], id: \.self) { index in
                    TipItemView(content: tips[index].title)
                        .transition(.push(from: .top))
                }
            }
            .animation(.easeInOut(duration: 0.8), value: viewModel.selectedIndex)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
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
                    .ignoresSafeArea(edges: .all)
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

#if DEBUG
#Preview {
    NavigationStack {
        TipBannerView(viewModel: TipBannerViewModel())
    }
}
#endif
