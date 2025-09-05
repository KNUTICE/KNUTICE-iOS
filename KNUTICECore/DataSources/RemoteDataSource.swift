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
    
    /// Sends an HTTP request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL as a `String`.
    ///   - method: The HTTP method to use (e.g., `.get`, `.post`).
    ///   - parameters: Optional request parameters as a `Parameters` dictionary (usually `[String: Any]`).
    ///   - type: The expected `Decodable` type to decode the response into.
    ///   - isInterceptable: A flag indicating whether the request should be intercepted (e.g., for authentication handling).
    ///
    /// - Returns: A decoded object of type `T`.
    ///
    /// - Throws: An error if the request fails or the response cannot be decoded.
    ///
    /// - Note: This is an asynchronous function and must be called with `await`.
    func request<T>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        decoding type: T.Type,
        isInterceptable: Bool
    ) async throws -> T where T: DTORepresentable
    
    /// Sends an HTTP request and publishes a decoded response of the specified type.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL as a `String`.
    ///   - method: The HTTP method to use (e.g., `.get`, `.post`).
    ///   - parameters: Optional request parameters as a `Parameters` dictionary (usually `[String: Any]`).
    ///   - type: The expected `Decodable` type to decode the response into.
    ///
    /// - Returns: An `AnyPublisher` that publishes a decoded object of type `T` or an `Error`.
    ///
    /// - Note: The publisher performs the network request and decoding. Subscribe on an appropriate thread and handle cancellation if needed.
    func request<T>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        decoding type: T.Type
    ) -> AnyPublisher<T, any Error> where T: DTORepresentable
    
    /// Sends an HTTP request and emits a single decoded response of the specified type.
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
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) async throws -> T where T: DTORepresentable {
        return try await self.request(url, method: method, parameters: parameters, decoding: type, isInterceptable: isInterceptable)
    }
    
    func request<T>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type
    ) -> AnyPublisher<T, any Error> where T: DTORepresentable {
        return request(url, method: method, parameters: parameters, decoding: type)
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
    
    public func request<T>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type,
        isInterceptable: Bool = false
    ) async throws -> T where T : DTORepresentable {
        return try await session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            interceptor: isInterceptable ? TokenInterceptor() : nil
        )
        .serializingDecodable(type)
        .value
    }
    
    public func request<T>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type
    ) -> AnyPublisher<T, any Error> where T : DTORepresentable {
        return session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default
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
