//
//  UITabViewController+DeepLink.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/9/26.
//

import ComposableArchitecture
import Foundation
import KNCore
import KNDeepLink
import KNMeal
import KNReadingRoom
import SwiftUI
import UIKit

extension UITabBarViewController {
    func handle(deepLink: DeepLink) {
        let viewController: UIViewController
        
        switch deepLink {
        case let .bookmark(nttId):
            let store = Store(
                initialState: BookmarkContainerFeature.State.detail(BookmarkDetailFeature.State(nttId: nttId)),
                reducer: { BookmarkContainerFeature() }
            )
            let rootView = BookmarkContainerView(
                store: store
            ) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            viewController = UIHostingController(rootView: rootView)
            
        case let .notice(nttId, _):
            viewController = NoticeContentViewController(
                viewModel: NoticeContentViewModel(nttId: nttId)
            )
            
        case let .navigation(tabIndex):
            // iPadOS 18.0부터 UITab API를 사용
            // `selectedTab`을 변경하여 선택된 탭 이동
            if #available(iOS 18, *), UIDevice.current.userInterfaceIdiom == .pad {
                guard tabs.indices.contains(tabIndex) else { return }
                
                self.selectedTab = tabs[tabIndex]
            } else {
                guard let vcs = self.viewControllers, vcs.indices.contains(tabIndex) else { return }
                
                self.selectedIndex = tabIndex
                self.tabBarController(self, didSelect: vcs[tabIndex])
            }
            return
            
        case let .meal(cafeteria):
            viewController = UIHostingController(rootView: MealView(cafeteria: cafeteria))
            
        case let .readingRoom(roomId):
            viewController = ReadingRoomStatusViewController(roomId: roomId)
            
        case .unknown:
            return
            
        }
        
        navigationController?.popToRootViewController(animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
