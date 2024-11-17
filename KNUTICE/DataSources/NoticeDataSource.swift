//
//  GeneralNoticeDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Alamofire

protocol NoticeDataSource {
    func fetchNotices(from url: String) -> Single<NoticeReponseDTO>
}

final class NoticeDataSourceImpl: NoticeDataSource {
    func fetchNotices(from url: String) -> Single<NoticeReponseDTO> {
        return Single.create { observer in
            AF.request(url)
                .responseDecodable(of: NoticeReponseDTO.self) { response in
                    switch response.result {
                    case .success(let dto):
                        observer(.success(dto))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create()
        }
    }
}
