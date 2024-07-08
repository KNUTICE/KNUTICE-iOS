//
//  ViewModelProtocol.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import RxCocoa
import RxSwift

protocol ViewModel {
    var notices: BehaviorRelay<[Notice]> { get }
    var isFetching: BehaviorRelay<Bool> { get }
    
    func fetchNotices()
}

extension ViewModel {
    var noticesObservable: Observable<[Notice]> {
        return notices.asObservable()
    }
    
    var isFetchingObservable: Observable<Bool> {
        return isFetching.asObservable()
    }
    
    func getNotices() -> [Notice] {
        return notices.value
    }
}
