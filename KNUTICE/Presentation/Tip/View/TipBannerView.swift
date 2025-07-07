//
//  TipBannerView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import SwiftUI

struct TipBannerView: View {
    @EnvironmentObject private var viewModel: TipBannerViewModel
    @State private var isShowingFullScreen: Bool = false
    @State private var selectedItem: Int = 0
    
    var body: some View {
        if let tips = viewModel.tips {
            ZStack {
                Color.primaryBackground
                
                TabView(selection: $selectedItem) {
                    ForEach(tips.indices, id: \.self) { idx in
                        TipItemView(content: tips[idx].title)
                            .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .background(.mainCellBackground)
                .cornerRadius(10)
                .padding([.leading, .trailing, .bottom], 16)
                .frame(height: 70)
                .padding(.top)
                .onTapGesture {
                    viewModel.selectedURL = tips[selectedItem].contentURL
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
                
                if tips.count > 1 {
                    PageIndicator(selectedItem: $selectedItem, range: tips.indices)
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
            .font(.footnote)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing])
    }
}

fileprivate struct PageIndicator: View {
    @Binding var selectedItem: Int
    let range: Range<Int>
    
    var body: some View {
        HStack {
            ForEach(range, id: \.self) { idx in
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundStyle(idx == selectedItem ? .accent2 : .gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .offset(x: -30, y: -18)
    }
}

#Preview {
    NavigationStack {
        TipBannerView()
            .environmentObject(TipBannerViewModel())
    }
}
