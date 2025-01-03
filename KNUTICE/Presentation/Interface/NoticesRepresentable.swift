//
//  ViewModelProtocol.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxRelay
import RxSwift

protocol NoticesRepresentable {
    var notices: BehaviorRelay<[Notice]> { get }
    var noticesCount: Int { get }
}

extension NoticesRepresentable {
    var noticesObservable: Observable<[Notice]> {
        return notices.asObservable()
    }
    
    var noticesCount: Int {
        return getNotices().count
    }
    
    func getNotices() -> [Notice] {
        return notices.value
    }
}
