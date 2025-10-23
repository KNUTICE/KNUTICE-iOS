//
//  UITabBarViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/24/25.
//

import Combine
import Foundation
import SwiftUI
import UIKit

extension UITabBarViewController {
    func bind() {
        viewModel.$deepLink
            .sink(receiveValue: { [weak self] deepLink in
                guard let deepLink else { return }
                
                let viewController: UIViewController
                
                switch deepLink {
                case .bookmark(let nttId):
                    viewController = UIHostingController(
                        rootView: BookmarkDetailSwitchView(viewModel: BookmarkViewModel(nttId: nttId))
                    )
                case .meal:
                    // TODO: 학식 알림 딥링크 구현
                    return
                case .notice(let nttId, _):
                    viewController = NoticeContentViewController(
                        viewModel: NoticeContentViewModel(nttId: nttId)
                    )
                case .unknown:
                    return
                }
                
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            })
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink(receiveValue: { [weak self] _ in
                // FIXME: 중복 호출 문제 수정
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
