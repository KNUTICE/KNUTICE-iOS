//
//  UITabBarViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/24/25.
//

import Combine
import ComposableArchitecture
import Foundation
import KNCore
import KNDeepLink
import KNUtility
import SwiftUI
import UIKit

extension UITabBarViewController {
    func bind() {        
        NotificationCenter.default.publisher(for: .didReceiveDeepLink)
            .compactMap { $0.object as? DeepLink }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] deepLink in
                self?.handle(deepLink: deepLink)
            })
            .store(in: &cancellables)
        
        viewModel.$bookmarkSortOption
            .dropFirst()
            .sink(receiveValue: { [weak self] sortOption in
                // 선택된 정렬 옵션으로 UI 업데이트
                self?.setThirdTabNavigationItems(selectedOption: sortOption)
                
                // 선택된 정렬 조건으로 리스트를 업데이트 하기 위해 BookmarkTableViewController로 전달
                NotificationCenter.default.post(
                    name: Notification.Name.bookmarkSortOptionDidChange,
                    object: self,
                    userInfo: [UserInfoKeys.bookmarkSortOption.rawValue: sortOption]
                )
            })
            .store(in: &cancellables)
        
        DeepLinkManager.shared.notificationPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .map { DeepLinkManager.shared.parse($0) }
            .sink(receiveValue: { [weak self] deepLink in
                self?.handle(deepLink: deepLink)
            })
            .store(in: &cancellables)
    }
}
