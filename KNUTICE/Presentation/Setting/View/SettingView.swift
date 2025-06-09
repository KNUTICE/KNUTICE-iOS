//
//  SettingView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import SwiftUI
import Combine
import Factory

struct SettingView: View {
    @State private var isShowingReport: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        List {
            Section {
                Text("알림")
                    .bold()
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                
                NavigationLink {
                    TopicSubscriptionList(viewModel: TopicSubscriptionListViewModel())
                } label: {
                    Text("서비스 알림")
                }
                .listRowSeparator(.hidden)
            }
            
            Divider()
                .listRowSeparator(.hidden)
            
            Section {
                Text("지원")
                    .bold()
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                
                Button {
                    isShowingReport.toggle()
                } label: {
                    HStack {
                        Text("고객센터")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.chevronGray)
                            .bold()
                            .font(.footnote)
                    }
                }
                .listRowSeparator(.hidden)
            }
            
            Divider()
                .listRowSeparator(.hidden)
            
            Section {
                Text("앱 정보")
                    .bold()
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                
                NavigationLink {
                    AppVersionView(viewModel: AppVersionViewModel())
                } label: {
                    Text("버전 정보")
                }
                .listRowSeparator(.hidden)
                
                NavigationLink {
                    ContentWebView(navigationTitle: "오픈소스 라이선스", contentURL: Bundle.main.openSourceURL)
                } label: {
                    Text("오픈소스 라이선스")
                }
                .listRowSeparator(.hidden)
            }
            
            #if DEV
            
            Divider()
                .listRowSeparator(.hidden)
            
            Section {
                Text("개발")
                    .bold()
                    .padding(.bottom)
                    .listRowSeparator(.hidden)
                
                NavigationLink {
                    DeveloperTools(viewModel: DeveloperToolsViewModel())
                } label: {
                    Text("Developer Tools")
                }
            }
            .listRowSeparator(.hidden)
            
            Divider()
                .listRowSeparator(.hidden)
            #endif
        }
        .listStyle(.plain)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingReport) {
            NavigationView {
                ReportView(viewModel: Container.shared.reportViewModel())
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingView()
    }
}
