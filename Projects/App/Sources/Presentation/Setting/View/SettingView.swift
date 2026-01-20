//
//  SettingView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import Combine
import ComposableArchitecture
import KNReport
import Factory
import SwiftUI

struct SettingView: View {
    @State private var isShowingReport: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            ContentSection("알림") {
                NavigationLink {
                    TopicSubscriptionList(
                        store: Store(initialState: TopicSubscriptionListFeature.State()) {
                            TopicSubscriptionListFeature()
                        }
                    )
                } label: {
                    NavigationIndicator(title: "서비스 알림")
                }
            }
            
            ContentSection("지원") {
                Button {
                    isShowingReport.toggle()
                } label: {
                    NavigationIndicator(title: "고객센터")
                }
            }
            
            ContentSection("앱 정보") {
                NavigationLink {
                    AppVersionView(viewModel: AppVersionViewModel())
                } label: {
                    NavigationIndicator(title: "버전 정보")
                }
                .padding(.bottom)
                
                NavigationLink {
                    BaseWebContentView(navigationTitle: "오픈소스 라이선스", contentURL: Bundle.main.openSourceURL)
                } label: {
                    NavigationIndicator(title: "오픈소스 라이선스")
                }
            }
            
            #if DEV
            
            ContentSection("개발자 도구") {
                NavigationLink {
                    DeveloperTools(viewModel: DeveloperToolsViewModel())
                } label: {
                    NavigationIndicator(title: "Developer Tools")
                }
            }
            #endif
        }
        .listStyle(.insetGrouped)
        .background(KNUTICEAsset.primaryBackground.swiftUIColor)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingReport) {
            NavigationView {
                ReportView(
                    store: Store(initialState: ReportFeature.State()) {
                        ReportFeature()
                    }
                )
            }
        }
    }
}

fileprivate struct ContentSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .padding(.bottom)
            
            content()
        }
        .padding()
        .background(KNUTICEAsset.mainCellBackground.swiftUIColor)
        .cornerRadius(20)
        .padding()
    }
}

fileprivate struct NavigationIndicator: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(KNUTICEAsset.chevronGray.swiftUIColor)
                .bold()
                .font(.footnote)
        }
    }
}

#Preview {
    NavigationView {
        SettingView()
    }
}
