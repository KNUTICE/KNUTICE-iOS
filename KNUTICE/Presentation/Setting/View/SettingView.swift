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
            Section(header: Text("알림")) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("서비스 알림")
                        
                        Toggle("", isOn: Binding(
                            get: {
                                self.viewModel.isToggleOn
                            },
                            set: { _, _ in })
                        )
                        .tint(.indigo)
                        .onTapGesture {
                            if #available(iOS 16.0, *) {
                                Task {
                                    if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                                        // Ask the system to open that URL.
                                        await UIApplication.shared.open(url)
                                    }
                                }
                            } else {
                                Task {
                                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                        await UIApplication.shared.open(appSettings)
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("새로운 공지사항이 등록되면 푸시 알림으로 알려드려요.")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                .padding([.top, .bottom], 8)
            }
            .listRowBackground(Color.customBackground)
            
            Section(header: Text("앱 정보")) {
                HStack {
                    Text("버전 정보")
                    
                    Spacer()
                    
                    Text("\(viewModel.appVersion)(beta)")
                }
                .padding([.top, .bottom], 10)
                
                NavigationLink(destination: {
                    OpenSourceLicenseView()
                }, label: {
                    Text("오픈소스 라이선스")
                })
                .padding([.top, .bottom], 10)
            }
            .listRowBackground(Color.customBackground)
        }
        .background(.customBackground)
        .listStyle(.plain)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getAppVersion()
            viewModel.getNotificationSettings()
        }
    }
}

#Preview {
    NavigationView {
        SettingView(viewModel: AppDI.shared.settingViewModel)
    }
}
