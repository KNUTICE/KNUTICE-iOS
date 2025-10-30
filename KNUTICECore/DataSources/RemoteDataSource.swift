//
//  RemoteDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/31/24.
//

import RxSwift
import Combine
import Alamofire

// MARK: - RemoteDatSource

public protocol RemoteDataSource: Sendable {
    typealias DTORepresentable = Decodable & Sendable
    
    /// Sends an asynchronous HTTP request and decodes the response into a specified DTO type.
    ///
    /// This method wraps an Alamofire request into Swift Concurrency's `async/await` style,
    /// handling JSON encoding, optional headers, and request interception when needed.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL string.
    ///   - method: The HTTP method to use (e.g., `.get`, `.post`, `.patch`).
    ///   - parameters: Optional request parameters to include in the body (JSON encoded).
    ///   - headers: Optional custom HTTP headers.
    ///   - type: The expected response type conforming to `DTORepresentable`.
    ///   - isInterceptable: A Boolean indicating whether the request should use a `TokenInterceptor`
    ///     to automatically attach an FCM token. Defaults to `false`.
    ///
    /// - Returns: A decoded object of the specified `DTORepresentable` type.
    /// - Throws:
    ///   - `NetworkError.invalidURL` if the provided URL is invalid.
    ///   - Any error thrown during the network request or JSON decoding process.
    ///
    @discardableResult
    func request<T>(
        _ url: String,
        method: HTTPMethod,
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
    ///   - method: The HTTP method to use (e.g., `.get`, `.post`, `.patch`).
    ///   - parameters: Optional request parameters to include in the body (JSON encoded).
    ///   - headers: Optional custom HTTP headers.
    ///   - type: The expected response type conforming to `DTORepresentable`.
    ///   - isInterceptable: A Boolean indicating whether the request should use a `TokenInterceptor`
    ///     to automatically attach an FCM token. Defaults to `false`.
    ///
    /// - Returns: An `AnyPublisher` that publishes a decoded object of type `T` on success,
    ///   or an `Error` if the request or decoding fails.
    ///
    func request<T>(
        _ url: String,
        method: HTTPMethod,
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
    ///   - url: The endpoint URL as a `String`.
    ///   - method: The HTTP method to use (e.g., `.get`, `.post`).
    ///   - parameters: Optional request parameters as a `Parameters` dictionary (typically `[String: Any]`).
    ///   - type: The expected `Decodable` type to decode the response into.
    ///
    /// - Returns: A `Single` that emits a decoded object of type `T` on success, or an error on failure.
    ///
    /// - Note: Use this method for one-time network requests that return a single value. The request is performed when subscribed to.
    @available(*, deprecated)
    func request<T>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        decoding type: T.Type
    ) -> Single<T> where T: DTORepresentable
}

public extension RemoteDataSource {
    @discardableResult
    func request<T>(
        _ url: String,
        method: HTTPMethod,
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
        method: HTTPMethod,
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
        method: HTTPMethod,
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
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) async throws -> T where T : DTORepresentable {
        return try await session.request(
            url,
            method: method,
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
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) -> AnyPublisher<T, any Error> where T : DTORepresentable {
        return session.request(
            url,
            method: method,
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
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type
    ) -> Single<T> where T : DTORepresentable {
        return Single.create {
            try await self.request(url, method: method, parameters: parameters, decoding: T.self)
        }
    }
}
