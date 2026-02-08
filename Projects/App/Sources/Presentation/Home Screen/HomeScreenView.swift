//
//  HomeScreenView.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/6/26.
//

import ComposableArchitecture
import KNCore
import KNDesignSystem
import KNTip
import KNUtility
import SwiftUI

struct HomeScreenView: View {
    @State private var store: StoreOf<HomeScreenFeature>
    
    init(store: StoreOf<HomeScreenFeature>) {
        self.store = store
        
        UIPageControl.appearance().currentPageIndicatorTintColor = KNDesignSystemAsset.accent2.color
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.secondary)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TipBannerView(viewModel: TipBannerViewModel())
                
                HStack(spacing: 20) {
                    NavigationLink {
                        
                    } label: {
                        HomeCardView(title: "학식 조회") {
                            Image("icon_dining_menu")
                        }
                    }
                    
                    NavigationLink {
                    
                    } label: {
                        HomeCardView(title: "열람실 조회") {
                            Image("icon_study_area")
                        }
                    }
                }
                
                TabView {
                    ForEach(store.sectionedNotices, id: \.header) { section in
                        NoticeList(notices: section)
                    }
                }
                .padding(.top, -30)
                .frame(minHeight: 330)
                .tabViewStyle(.page(indexDisplayMode: .always))
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
                }
                
                switch store.majorNotices {
                case let .loaded(majorNotices):
                    NoticeList(notices: majorNotices)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
                        }
                    
                case .empty:
                    EmptyMajorNoticeView()
                    
                default:
                    Color.clear
                }
                
            }
            .padding([.leading, .trailing, .bottom])
        }
        .background(KNDesignSystemAsset.primaryBackground.swiftUIColor)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

fileprivate struct HomeCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let icon: () -> Image
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .bold()
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(colorScheme == .light ? .black : .white)
            
            icon()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 110)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding([.leading, .top])
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        }
    }
}

fileprivate struct NoticeList: View {
    let notices: MainSectionNotice
    
    var body: some View {
        VStack {
            HStack {
                Text(notices.header)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .redacted(reason: notices.items.first?.presentationType == .skeleton ? .placeholder : [])
                
                NavigationLink {
                    if let category = notices.category as? NoticeCategory {
                        NoticeCollectionView(
                            viewModel: NoticeCollectionViewModel(category: category)
                        )
                        .edgesIgnoringSafeArea(.all)
                        .navigationTitle(category.localizedDescription)
                    }
                } label: {
                    Text("더보기")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            
            ForEach(Array(notices.items.enumerated()), id: \.element.notice.id) { index, item in
                NavigationLink {
                    // 상세 화면 이동
                    NoticeContentView(notice: item.notice)
                } label: {
                    NoticeListRow(notice: item.notice)
                        .redacted(reason: item.presentationType == .skeleton ? .placeholder : [])
                        
                }
                
                // 마지막 아이템이 아닐 때만 구분선 추가
                if index < notices.items.count - 1 {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.horizontal, 4)
                }
            }
        }
        .padding()
    }
}

fileprivate struct NoticeListRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notice.title)
                .font(.subheadline)
                .bold()
                .lineLimit(1)
                .foregroundStyle(colorScheme == .light ? .black : .white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 5) {
                Text("[" + notice.department + "]")
                Text(notice.uploadDate)
            }
            .foregroundStyle(KNDesignSystemAsset.subTitle.swiftUIColor)
            .font(.caption)
            
        }
        .padding([.top, .bottom])
    }
}

fileprivate struct EmptyMajorNoticeView: View {
    var body: some View {
        VStack(spacing: 16) {
            // 아이콘 부분
            Image(systemName: "graduationcap.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(KNDesignSystemAsset.gray3.swiftUIColor)
                .padding(.top, 20)
            
            // 안내 텍스트
            Text("학과를 선택하면 학과 소식을 받아 볼 수 있어요.")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // 학과 선택 버튼
            Button {
                
            } label: {
                Text("학과 선택하기")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background {
                        Capsule()
                            .fill(KNDesignSystemAsset.accent2.swiftUIColor)
                    }
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreenView(store: .init(initialState: HomeScreenFeature.State()) {
            HomeScreenFeature()
        })
    }
}
