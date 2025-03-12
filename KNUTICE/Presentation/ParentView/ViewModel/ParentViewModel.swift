//
//  ParentViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import Factory
import Foundation
import RxSwift
import RxRelay

final class ParentViewModel {
    let isFinishedTokenRegistration: BehaviorRelay<Bool> = .init(value: false)
    @Injected(\.tokenRepository) private var repository: TokenRepository
    private let disposeBag: DisposeBag = DisposeBag()
    
    private func register(token: String) {
        repository.registerToken(token: token)
            .subscribe(onNext: { [weak self] in
                self?.isFinishedTokenRegistration.accept($0)
                if $0 {
                    print("Successfully to save FCM Token")
                } else {
                    print("Failed to save FCM Token")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func subscribeToFCMToken() {
        NotificationCenter.default.rx.notification(.fcmToken)
            .subscribe(onNext: { [weak self] notification in
                guard let fcmToken = notification.userInfo?["token"] as? String else {
                    return
                }
                
                self?.register(token: fcmToken)
            })
            .disposed(by: disposeBag)
    }
}
