//
//  RemoteDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/31/24.
//

import RxSwift
import Combine
import Alamofire

// MARK: - RemoteDataSource

/// A protocol that defines a unified interface for performing remote HTTP requests.
///
/// `RemoteDataSource` abstracts networking logic and provides multiple asynchronous
/// access patterns (`async/await`, Combine, RxSwift) to support different layers
/// and legacy code paths.
///
/// This protocol is intended to be used in the Data layer of a Clean Architecture setup.
public protocol RemoteDataSource: Sendable {
    typealias DTORepresentable = Decodable & Sendable
    
    /// Sends an HTTP request using Swift Concurrency and decodes the response.
    ///
    /// This method internally uses Alamofire and exposes it as an `async/await` API,
    /// enabling structured concurrency and cancellation support.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL string.
    ///   - method: The HTTP method represented by `RequestMethod`.
    ///   - parameters: Optional parameters encoded as JSON.
    ///   - headers: Optional HTTP headers.
    ///   - type: The expected response DTO type.
    ///   - isInterceptable: Indicates whether a `TokenInterceptor` should be applied.
    ///
    /// - Returns: A decoded DTO of type `T`.
    /// - Throws: Any networking or decoding error.
    @discardableResult
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        decoding type: T.Type,
        isInterceptable: Bool
    ) async throws -> T where T: DTORepresentable
    
    /// Sends an HTTP request and publishes the decoded response as a Combine publisher.
    ///
    /// This method wraps an Alamofire request into a Combine `AnyPublisher`,
    /// automatically handling JSON encoding, optional headers, and token interception if enabled.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL string.
    ///   - method: The HTTP method represented by `RequestMethod`.
    ///   - parameters: Optional parameters encoded as JSON.
    ///   - headers: Optional HTTP headers.
    ///   - type: The expected response DTO type.
    ///   - isInterceptable: Indicates whether a `TokenInterceptor` should be applied.
    ///
    /// - Returns: An `AnyPublisher` that publishes a decoded object of type `T` on success,
    ///   or an `Error` if the request or decoding fails.
    ///
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        decoding type: T.Type,
        isInterceptable: Bool
    ) -> AnyPublisher<T, any Error> where T: DTORepresentable
    
    /// Sends an HTTP request and emits a single decoded response of the specified type.
    ///
    /// - Warning: **Deprecated**
    ///   - This method is deprecated and may be removed in future versions.
    ///   - Use `request(_:method:parameters:headers:decoding:isInterceptable:)` or other supported methods instead.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL string.
    ///   - method: The HTTP method represented by `RequestMethod`.
    ///   - parameters: Optional parameters encoded as JSON.
    ///   - headers: Optional HTTP headers.
    ///   - type: The expected response DTO type.
    ///   - isInterceptable: Indicates whether a `TokenInterceptor` should be applied.
    ///
    /// - Returns: A `Single` that emits a decoded object of type `T` on success, or an error on failure.
    ///
    /// - Note: Use this method for one-time network requests that return a single value. The request is performed when subscribed to.
    @available(*, deprecated)
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters?,
        decoding type: T.Type
    ) -> Single<T> where T: DTORepresentable
}

public extension RemoteDataSource {
    @discardableResult
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) async throws -> T where T: DTORepresentable {
        return try await self.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            decoding: type,
            isInterceptable: isInterceptable
        )
    }
    
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) -> AnyPublisher<T, any Error> where T: DTORepresentable {
        return request(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            decoding: type,
            isInterceptable: isInterceptable
        )
    }
    
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type
    ) -> Single<T> where T: DTORepresentable {
        return request(url, method: method, parameters: parameters, decoding: type)
    }
}

// MARK: - RemoteDataSourceImpl

public final class RemoteDataSourceImpl: RemoteDataSource, Sendable {
    private let session: Session
    
    public init(session: Session = Session.default) {
        self.session = session
    }
    
    @discardableResult
    public func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) async throws -> T where T : DTORepresentable {
        return try await session.request(
            url,
            method: method.alamofire,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            interceptor: isInterceptable ? TokenInterceptor() : nil
        )
        .serializingDecodable(type)
        .value
    }
    
    public func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) -> AnyPublisher<T, any Error> where T : DTORepresentable {
        return session.request(
            url,
            method: method.alamofire,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            interceptor: isInterceptable ? TokenInterceptor() : nil
        )
        .publishDecodable(type: T.self)
        .value()
        .mapError {
            $0 as Error
        }
        .eraseToAnyPublisher()
    }
    
    public func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type
    ) -> Single<T> where T : DTORepresentable {
        return Single.create {
            try await self.request(url, method: method, parameters: parameters, decoding: T.self)
        }
    }
}
