//
//  SearchTableProtocol.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/25/24.
//

import RxRelay
import RxSwift

protocol SearchResultRepresentable {
    var notices: BehaviorRelay<[Notice]?> { get }
    var tableData: Observable<[Notice]> { get }
    
    func search(_ keyword: String)
}

extension SearchResultRepresentable {
    var noticesObservable: Observable<[Notice]?> {
        return notices.asObservable()
    }
    
    func getNotices() -> [Notice]? {
        return notices.value
    }
}
