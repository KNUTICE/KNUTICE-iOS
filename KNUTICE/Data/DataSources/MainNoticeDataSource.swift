//
//  MainNoticeDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift
import Alamofire

protocol MainNoticeDataSource {
    func fetchMainNotices() -> Observable<Result<MainNoticeDTO, Error>>
}

final class MainNoticeDataSourceImpl: MainNoticeDataSource {
    func fetchMainNotices() -> Observable<Result<MainNoticeDTO, Error>> {
        let url = Bundle.main.url
        return Observable.create { observer in
            AF.request("\(url)/main")
                .responseDecodable(of: MainNoticeDTO.self) { response in
                    switch response.result {
                    case .success(let result):    //success
                        observer.onNext(.success(result))
                    case .failure(let error):    //fail
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
