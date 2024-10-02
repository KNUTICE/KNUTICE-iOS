//
//  TokenDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import RxSwift
import Alamofire

protocol TokenDataSource {
    func sendPostRequest(to url: String, params: Parameters) -> Observable<Result<TokenSaveResponseDTO, Error>>
}

final class TokenDataSourceImpl: TokenDataSource {
    func sendPostRequest(to url: String, params: Parameters) -> Observable<Result<TokenSaveResponseDTO, any Error>> {
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default)
                .responseDecodable(of: TokenSaveResponseDTO.self) { response in
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
