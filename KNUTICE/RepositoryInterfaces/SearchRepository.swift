//
//  SearchRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import KNUTICECore
import RxSwift

protocol SearchRepository: Sendable {
    func search(keyword: String) -> Single<[Notice]>
    func search(with keyword: String) async throws -> [Notice]
}
