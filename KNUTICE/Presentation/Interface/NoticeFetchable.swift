//
//  NoticeFetchable.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/17/24.
//

import RxRelay
import RxSwift

protocol NoticeFetchable {
    var isFetching: BehaviorRelay<Bool> { get }
    
    func fetchNotices()
}

extension NoticeFetchable {
    var isFetchingObservable: Observable<Bool> {
        return isFetching.asObservable()
    }
}