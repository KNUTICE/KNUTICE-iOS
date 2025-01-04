//
//  RemoteDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/31/24.
//

import RxSwift
import Combine
import Alamofire

protocol RemoteDataSource {
    func sendGetRequest<T: Decodable>(to url: String,
                                      resultType: T.Type) -> Single<T>
    
    func sendPostRequest<T: Decodable>(to url: String,
                                       params: Parameters,
                                       resultType: T.Type) -> Single<T>
    
    func sendPostRequest<T: Decodable>(to url: String,
                                       params: Parameters,
                                       resultType: T.Type) -> AnyPublisher<T, any Error>
}

final class RemoteDataSourceImpl: RemoteDataSource {
    private init() {}
    
    static let shared = RemoteDataSourceImpl()
    
    func sendGetRequest<T: Decodable>(to url: String,
                                      resultType: T.Type) -> Single<T> {
        return Single.create { observer in
            AF.request(url)
                .responseDecodable(of: resultType.self) { response in
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
    
    func sendPostRequest<T: Decodable>(to url: String,
                                       params: Parameters,
                                       resultType: T.Type) -> Single<T> {
        return Single.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: JSONEncoding.default)
                .responseDecodable(of: resultType.self) { response in
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
    
    func sendPostRequest<T: Decodable>(to url: String,
                                       params: Parameters,
                                       resultType: T.Type) -> AnyPublisher<T, any Error> {
        return AF.request(url,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
            .publishDecodable(type: T.self)
            .value()
            .mapError {
                $0 as Error
            }
            .eraseToAnyPublisher()
    }
}
