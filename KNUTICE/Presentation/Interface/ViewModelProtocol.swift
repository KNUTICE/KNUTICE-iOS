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
    func fetchNotices()
}

extension ViewModel {
    func getCellData() -> Observable<[Notice]> {
        return notices.asObservable()
    }
    
    func getNotices() -> [Notice] {
        return notices.value
    }
}
