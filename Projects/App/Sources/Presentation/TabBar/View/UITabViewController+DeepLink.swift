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
        case .bookmark(let nttId):
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
            
        case .notice(let nttId, _):
            viewController = NoticeContentViewController(
                viewModel: NoticeContentViewModel(nttId: nttId)
            )
            
        case .navigation(let tabIndex):
            guard let vcs = self.viewControllers, vcs.indices.contains(tabIndex) else { return }
            
            self.selectedIndex = tabIndex
            self.tabBarController(self, didSelect: vcs[tabIndex])
            return
            
        case .meal:
            viewController = UIHostingController(rootView: MealView())
            
        case .readingRoom(let roomId, let seat):
            viewController = UIHostingController(rootView: ReadingRoomStatusView())
            
        case .unknown:
            return
            
        }
        
        navigationController?.popToRootViewController(animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
