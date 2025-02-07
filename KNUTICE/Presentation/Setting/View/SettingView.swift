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
    @ObservedObject private var viewModel: SettingViewModel
    @State private var isShowingReport: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    init(viewModel: SettingViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    NotificationList(viewModel: AppDI.shared.createNotificationListViewModel())
                } label: {
                    Text("서비스 알림")
                }
                .padding([.top, .bottom])
            } header: {
                Text("알림")
            }
            .listRowBackground(Color.detailViewBackground)
            
            Section {
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
                .padding([.top, .bottom])
            } header: {
                Text("지원")
            }
            .listRowBackground(Color.detailViewBackground)
            
            Section {
                HStack {
                    Text("버전 정보")
                    
                    Spacer()
                    
                    Text("\(viewModel.appVersion)")
                }
                .padding([.top, .bottom])
                
                NavigationLink {
                    ContentWebView(navigationTitle: "오픈소스 라이선스", contentURL: Bundle.main.openSourceURL)
                } label: {
                    Text("오픈소스 라이선스")
                        .padding([.top, .bottom])
                }
            } header: {
                Text("앱 정보")
            }
            .listRowBackground(Color.detailViewBackground)
            
            #if DEV
            Section {
                NavigationLink {
                    DeveloperTools(viewModel: DeveloperToolsViewModel())
                } label: {
                    Text("Developer Tools")
                        .padding([.top, .bottom])
                }
            } header: {
                Text("개발")
            }
            .listRowBackground(Color.detailViewBackground)
            #endif
        }
        .background(.detailViewBackground)
        .listStyle(.plain)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getVersion()
            viewModel.getNotificationSettings()
        }
        .fullScreenCover(isPresented: $isShowingReport) {
            NavigationView {
                ReportView(viewModel: Container.shared.reportViewModel())
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingView(viewModel: SettingViewModel())
    }
}
