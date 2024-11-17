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
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SettingViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [self] _ in    //escaping 시점에 다른 메모리의 self를 캡쳐 하도록 함.
                self.viewModel.getNotificationSettings()
            }
            .store(in: &cancellables)
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        Text("서비스 알림")
                        
                        Toggle("", isOn: Binding(
                            get: {
                                self.viewModel.isToggleOn
                            },
                            set: { _, _ in
                                Task {
                                    if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                                        // Ask the system to open that URL.
                                        await UIApplication.shared.open(url)
                                    }
                                }
                            })
                        )
                        .tint(.indigo)
                    }
                    
                    Text("새로운 공지사항이 등록되면 푸시 알림으로 알려드려요.")
                        .font(.caption2)
                        .foregroundStyle(.gray)
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
                    Text("고객센터")
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
                
                Text("오픈소스 라이선스")
                    .padding([.top, .bottom])
                    .background {
                        NavigationLink("") {
                            OpenSourceLicenseView()
                        }
                        .opacity(0)
                    }
            } header: {
                Text("앱 정보")
            }
            .listRowBackground(Color.customBackground)
            
            #if DEV
            Section {
                Text("Developer Tools")
                    .padding([.top, .bottom])
                    .background {
                        NavigationLink("") {
                            DeveloperTools(viewModel: AppDI.shared.makeDeveloperToolsViewModel())
                        }
                        .opacity(0)
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
