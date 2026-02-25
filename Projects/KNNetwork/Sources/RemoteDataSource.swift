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
    /// - Parameters:
    ///   - url: The endpoint URL string.
    ///   - method: The HTTP method represented by `RequestMethod`.
    ///   - parameters: Optional parameters encoded as JSON body. Defaults to `nil`.
    ///   - headers: Optional HTTP headers to attach to the request. Defaults to `nil`.
    ///   - type: The expected response DTO type to decode into.
    ///   - useFCMToken: When `true`, a `NetworkInterceptor` that injects the FCM
    ///     registration token header is applied to the request. Defaults to `false`.
    ///
    /// - Returns: A decoded DTO of type `T`.
    /// - Throws: An `AFError` or decoding error if the request or deserialization fails.
    @discardableResult
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        decoding type: T.Type,
        useFCMToken: Bool
    ) async throws -> T where T: DTORepresentable
    
    /// Sends an HTTP request and publishes the decoded response as a Combine publisher.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL string.
    ///   - method: The HTTP method represented by `RequestMethod`.
    ///   - parameters: Optional parameters encoded as JSON body. Defaults to `nil`.
    ///   - headers: Optional HTTP headers to attach to the request. Defaults to `nil`.
    ///   - type: The expected response DTO type to decode into.
    ///   - useFCMToken: When `true`, a `NetworkInterceptor` that injects the FCM
    ///     registration token header is applied to the request. Defaults to `false`.
    ///
    /// - Returns: An `AnyPublisher` that emits a single decoded value of type `T`
    ///   on success, or an `Error` if the request or decoding fails.
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        decoding type: T.Type,
        useFCMToken: Bool
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
    /// Default implementation that forwards to the primary `async/await` overload
    /// with `parameters`, `headers`, and `useFCMToken` set to their default values.
    @discardableResult
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        useFCMToken: Bool = false
    ) async throws -> T where T: DTORepresentable {
        return try await self.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            decoding: type,
            useFCMToken: useFCMToken
        )
    }
    
    /// Default implementation that forwards to the primary Combine overload
    /// with `parameters`, `headers`, and `useFCMToken` set to their default values.
    func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        useFCMToken: Bool = false
    ) -> AnyPublisher<T, any Error> where T: DTORepresentable {
        return request(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            decoding: type,
            useFCMToken: useFCMToken
        )
    }
    
    /// Default implementation that forwards to the deprecated RxSwift overload
    /// with `parameters` set to its default value.
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

/// The concrete implementation of `RemoteDataSource` that uses Alamofire under the hood.
///
/// `RemoteDataSourceImpl` manages a single Alamofire `Session` and delegates all
/// request building, encoding, interception, and decoding to it.
/// Inject a custom `Session` during initialisation (e.g. in unit tests) to swap
/// out the underlying transport layer without changing call sites.
public final class RemoteDataSourceImpl: RemoteDataSource, Sendable {
    /// The Alamofire session used for all outgoing network requests.
    private let session: Session
    
    /// Creates a new `RemoteDataSourceImpl`.
    ///
    /// - Parameter session: The Alamofire `Session` to use. Defaults to `Session.default`.
    public init(session: Session = Session.default) {
        self.session = session
    }
    
    /// Executes the request with Alamofire and deserializes the response using `serializingDecodable`.
    ///
    /// A `NetworkInterceptor` is always attached; its `shouldContainFCMToken` flag
    /// is driven by the `useFCMToken` parameter.
    @discardableResult
    public func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        useFCMToken: Bool = false
    ) async throws -> T where T : DTORepresentable {
        return try await session.request(
            url,
            method: method.alamofire,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            interceptor: useFCMToken ? NetworkInterceptor(shouldContainFCMToken: true) : NetworkInterceptor(shouldContainFCMToken: false)
        )
        .serializingDecodable(type)
        .value
    }
    
    /// Executes the request with Alamofire and publishes the deserialized response
    /// through Combine's `publishDecodable` API.
    ///
    /// Any `AFError` emitted by Alamofire is cast to the existential `Error` type
    /// so the publisher signature remains protocol-agnostic.
    public func request<T>(
        _ url: String,
        method: RequestMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        decoding type: T.Type,
        useFCMToken: Bool = false
    ) -> AnyPublisher<T, any Error> where T : DTORepresentable {
        return session.request(
            url,
            method: method.alamofire,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            interceptor: useFCMToken ? NetworkInterceptor(shouldContainFCMToken: true) : NetworkInterceptor(shouldContainFCMToken: false)
        )
        .publishDecodable(type: T.self)
        .value()
        .mapError {
            $0 as Error
        }
        .eraseToAnyPublisher()
    }
    
    /// Wraps the `async/await` overload in an RxSwift `Single` for backward compatibility.
    ///
    /// FCM token injection is not supported in this deprecated path; use the
    /// `async/await` or Combine variants for requests that require the FCM header.
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
