//
//  GeneralNoticeDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Alamofire

protocol NoticeDataSource {
    func fetchNotices(from url: String) -> Observable<Result<NoticeReponseDTO, Error>>
}

final class NoticeDataSourceImpl: NoticeDataSource {
    func fetchNotices(from url: String) -> Observable<Result<NoticeReponseDTO, Error>> {
        return Observable.create { observer in
            AF.request(url)
                .responseDecodable(of: NoticeReponseDTO.self) { response in
                    switch response.result {
                    case .success(let result):
                        observer.onNext(.success(result))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
