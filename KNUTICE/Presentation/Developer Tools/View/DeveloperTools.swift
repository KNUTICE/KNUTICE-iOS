//
//  DeveloperTools.swift
//  KNUTICE dev
//
//  Created by 이정훈 on 11/2/24.
//

import SwiftUI

struct DeveloperTools: View {
    @StateObject private var viewModel: DeveloperToolsViewModel
    
    init(viewModel: DeveloperToolsViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            Section {
                if let fcmToken = viewModel.fcmToken {
                    HStack {
                        Text(fcmToken)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button {
                            UIPasteboard.general.string = viewModel.fcmToken
                        } label: {
                            Image(systemName: "document.fill")
                                .foregroundStyle(.gray)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding([.top, .bottom])
                } else {
                    ProgressView()
                        .padding([.top, .bottom])
                }
            } header: {
                Text("FCM Token")
            }
        }
        .listStyle(.plain)
        .navigationTitle("Developer Tools")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.fcmToken == nil {
                viewModel.fetchFCMToken()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperTools(viewModel: AppDI.shared.createDeveloperToolsViewModel())
    }
}
