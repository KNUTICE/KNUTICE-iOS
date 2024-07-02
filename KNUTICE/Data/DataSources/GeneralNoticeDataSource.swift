//
//  GeneralNoticeDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Alamofire

protocol GeneralNoticeDataSource {
    func fetchNotices() -> Observable<Result<GeneralNoticeDTO, Error>>
}

final class GeneralNoticeDataSourceImpl: GeneralNoticeDataSource {
    func fetchNotices() -> Observable<Result<GeneralNoticeDTO, Error>> {
        let url = Bundle.main.url
        
        return Observable.create { observer in
            AF.request("\(url)/generalNews")
                .responseDecodable(of: GeneralNoticeDTO.self) { response in
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
