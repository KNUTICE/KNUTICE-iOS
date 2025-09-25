//
//  UITabBarViewController+binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/24/25.
//

import Combine
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
                    if #available(iOS 26, *) {
                        viewController = UIHostingController(
                            rootView: NoticeDetailView()
                                .environment(NoticeDetailViewModel(noticeId: nttId))
                        )
                    } else {
                        viewController = NoticeContentViewController(
                            viewModel: NoticeContentViewModel(nttId: nttId)
                        )
                    }
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
    }
}
