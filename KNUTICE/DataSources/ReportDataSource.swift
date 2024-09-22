//
//  ReportDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Combine
import Alamofire

protocol ReportDataSource {
    func sendPostRequest(to url: String, params: [String: Any]) -> AnyPublisher<ReportResponseDTO, any Error>
}

final class ReportDataSourceImpl: ReportDataSource {
    func sendPostRequest(to url: String, params: [String : Any]) -> AnyPublisher<ReportResponseDTO, any Error> {
        return AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default)
        .publishDecodable(type: ReportResponseDTO.self)
        .value()
        .mapError {
            $0 as Error
        }
        .eraseToAnyPublisher()
    }
}
