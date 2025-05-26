//
//  AppVersionView.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/25/25.
//

import SwiftUI

struct AppVersionView: View {
    @StateObject private var viewModel: AppVersionViewModel
    
    init(viewModel: AppVersionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Image("Splash")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom, 30)
            
            Text("KNUTICE")
                .bold()
                .font(.title3)
            
            Text(viewModel.appVersion)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("버전 정보")
        .onAppear {
            viewModel.getVersion()
        }
    }
}

#Preview {
    NavigationStack {
        AppVersionView(viewModel: AppVersionViewModel())
    }
}
