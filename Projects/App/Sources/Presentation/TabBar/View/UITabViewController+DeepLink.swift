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
import KNDomain
import KNMeal
import KNNotice
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
            viewController = NoticeContentViewController(viewModel: NoticeContentViewModel(nttId: nttId)) { notice in
                let bookmark = Bookmark(notice: notice, memo: "")
                let rootView = BookmarkForm(
                    store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                        BookmarkFormFeature()
                    }
                ) { [weak self] in self?.dismiss(animated: true) }
                let viewController = UIHostingController(rootView: rootView)
                
                return viewController
            }
            
        case let .navigation(tabIndex, _):
            // iPadOS 18.0부터 UITab API를 사용
            // `selectedTab`을 변경하여 선택된 탭 이동
            if #available(iOS 18, *), UIDevice.current.userInterfaceIdiom == .pad {
                guard tabs.indices.contains(tabIndex) else { return }
                
                if let viewController = tabs[tabIndex].viewController as? NoticeTabViewController {
                    viewController.handle(deepLink: deepLink)
                }
                
                self.selectedTab = tabs[tabIndex]
            } else {
                guard let viewControllers = self.viewControllers, viewControllers.indices.contains(tabIndex) else { return }
                
                if let viewController = viewControllers[tabIndex] as? NoticeTabViewController {
                    viewController.handle(deepLink: deepLink)
                }
                
                self.selectedIndex = tabIndex
                self.tabBarController(self, didSelect: viewControllers[tabIndex])
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
