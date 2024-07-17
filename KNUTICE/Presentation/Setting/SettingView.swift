//
//  SettingView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import SwiftUI

struct SettingView: View {
    @State private var appVersion: String = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("버전 정보")
                    
                    Spacer()
                    
                    Text("\(appVersion)(alpha)")
                }
                .padding(10)
                
                NavigationLink(destination: {
                    OpenSourceLicenseView()
                }, label: {
                    Text("오픈소스 라이선스")
                })
                .padding(10)
            }
        }
        .listStyle(.plain)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            if let appVersion {
                self.appVersion = appVersion
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingView()
    }
}
