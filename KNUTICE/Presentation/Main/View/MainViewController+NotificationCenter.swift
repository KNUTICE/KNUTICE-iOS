//
//  MainViewController+NotificationCenter.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/15/24.
//

import RxSwift
import Foundation

extension MainViewController {
    //MARK: - App이 처음 실행 될 때 시간 기록
    func recordEntryTime() {
        DispatchQueue.global().async {
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "entryTime")
        }
    }
    
    //MARK: - Foreground 진입 감지
    func observeNotification() {
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] _ in
                let lastEntryTime = UserDefaults.standard.double(forKey: "entryTime")
                let timeDifference = Date().timeIntervalSince1970 - lastEntryTime
                
                //마지막 App 진입 시간과 30분 이상 차이나면 새로고침
                if timeDifference >= 1800 {
                    self?.recordEntryTime()
                    self?.viewModel.fetchNotices()
                }
            })
            .disposed(by: disposeBag)
    }
}
