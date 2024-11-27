//
//  NotificationList.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import SwiftUI

struct NotificationList: View {
    @StateObject private var viewModel: NotificationListViewModel
    
    init(viewModel: NotificationListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                viewModel.getNotificationPermissions()
            }
    }
}

#Preview {
    NotificationList(viewModel: AppDI.shared.makeNotificationListViewModel())
}
