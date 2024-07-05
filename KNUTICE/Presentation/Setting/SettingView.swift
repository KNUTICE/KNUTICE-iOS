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
                    Text("앱 버전")
                        .bold()
                    
                    Spacer()
                    
                    Text("\(appVersion)(alpha)")
                }
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
