//
//  SearchRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import RxSwift
import Foundation

final class SearchRepositoryImpl: SearchRepository, NoticeCreatable {
    private let dataSource: NoticeDataSource
    
    init(dataSource: NoticeDataSource) {
        self.dataSource = dataSource
    }
    
    func search(keyword: String) -> Single<[Notice]> {
        let url = Bundle.main.searchURL + "?keyword=\(keyword)"
        
        return dataSource.fetchNotices(from: url)
            .map { [weak self] in
                return self?.converToNotice($0) ?? []
            }
    }
}