//
//  NoticeTabRepresentable.swift
//  KNUtility
//
//  Created by 이정훈 on 4/12/26.
//

import Foundation

public protocol NoticeTabRepresentable: Identifiable {
    var id: String { get }
    var tabTitle: String { get }
}
