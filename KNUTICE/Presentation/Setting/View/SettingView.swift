//
//  SettingView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import SwiftUI
import Combine

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
                    NotificationList(viewModel: AppDI.shared.makeNotificationListViewModel())
                } label: {
                    Text("서비스 알림")
                }
                .padding([.top, .bottom])
            } header: {
                Text("알림")
            }
            .listRowBackground(Color.customBackground)
            
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
            .listRowBackground(Color.customBackground)
            
            Section {
                HStack {
                    Text("버전 정보")
                    
                    Spacer()
                    
                    Text("\(viewModel.appVersion)")
                }
                .padding([.top, .bottom])
                
                NavigationLink {
                    OpenSourceLicenseView()
                } label: {
                    Text("오픈소스 라이선스")
                        .padding([.top, .bottom])
                }
            } header: {
                Text("앱 정보")
            }
            .listRowBackground(Color.customBackground)
            
            #if DEV
            Section {
                NavigationLink {
                    DeveloperTools(viewModel: AppDI.shared.makeDeveloperToolsViewModel())
                } label: {
                    Text("Developer Tools")
                        .padding([.top, .bottom])
                }
            } header: {
                Text("개발")
            }
            .listRowBackground(Color.customBackground)
            #endif
        }
        .background(.customBackground)
        .listStyle(.plain)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getVersion()
            viewModel.getNotificationSettings()
        }
        .fullScreenCover(isPresented: $isShowingReport) {
            NavigationView {
                ReportView(viewModel: AppDI.shared.makeReportViewModel())
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingView(viewModel: AppDI.shared.makeSettingViewModel())
    }
}
