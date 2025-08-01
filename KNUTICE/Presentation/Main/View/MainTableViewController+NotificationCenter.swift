//
//  MainTableViewController+NotificationCenter.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/15/24.
//

import Foundation
import RxSwift
import UIKit

extension MainTableViewController: EntryTimeRecordable {
    //MARK: - Foreground 진입 감지
    func subscribeEntryTime() {
        foregroundPublisher
            .sink(receiveValue: { [weak self] _ in
                //마지막 App 진입 시간과 30분 이상 차이나면 새로고침
                if let time = self?.timeIntervalSinceLastEntry(), time >= 1800 {
                    self?.recordEntryTime()
                    self?.viewModel.fetchNoticesWithCombine()
                }
            })
            .store(in: &cancellables)
    }
}
