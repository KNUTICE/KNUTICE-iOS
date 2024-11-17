//
//  ViewModelProtocol.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxCocoa
import RxSwift

protocol NoticesRepresentable {
    var notices: BehaviorRelay<[Notice]> { get }
}

extension NoticesRepresentable {
    var noticesObservable: Observable<[Notice]> {
        return notices.asObservable()
    }
    
    func getNotices() -> [Notice] {
        return notices.value
    }
}
