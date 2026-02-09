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
        viewModel.$deepLink
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] deepLink in
                guard let self else { return }
                
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
                    
                case .meal:
                    // TODO: 학식 알림 딥링크 구현
                    return
                    
                case let .notice(nttId, _):
                    viewController = NoticeContentViewController(
                        viewModel: NoticeContentViewModel(nttId: nttId)
                    )
                    
                default:
                    return
                }
                
                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .didReceiveDeepLink)
            .compactMap { $0.object as? DeepLink }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] deepLink in
                guard let self, case let .navigation(tabIndex) = deepLink else { return }
                guard let vcs = self.viewControllers, vcs.indices.contains(tabIndex) else { return }
                
                self.selectedIndex = tabIndex
                self.tabBarController(self, didSelect: vcs[tabIndex])
            })
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink(receiveValue: { [weak self] _ in
                // FIXME: 중복 호출 문제 수정, Cold Start에서는 호출되지 않음
                self?.viewModel.fetchDeepLinkIfExists()
            })
            .store(in: &cancellables)
        
        viewModel.$category
            .sink(receiveValue: { [weak self] category in
                guard let category else { return }
                
                // 버튼 타이틀 변경
                self?.makeMajorSelectionButton(withTitle: category.localizedDescription)
                
                // 선택 된 전공 MajorNoticeCollectionViewController로 전달
                NotificationCenter.default.post(
                    name: Notification.Name.majorSelectionDidChange,
                    object: self,
                    userInfo: [UserInfoKeys.selectedMajor: category]
                )
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
    }
}
