//
//  NoticeCollectionViewControllerFactory.swift
//  KNNotice
//
//  Created by 이정훈 on 5/6/26.
//

import KNUtility

@MainActor
public protocol NoticeCollectionViewControllerFactory {
    func make(for category: any CategoryProtocol) -> NoticeCollectionViewController?
}
