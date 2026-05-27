//
//  ReportRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import Foundation
import Factory
import KNDomain
import KNNetwork
import KNUtility

/// The concrete implementation of `ReportRepository` that submits user reports
/// to the remote server via `RemoteDataSource`.
///
/// `ReportRepositoryImpl` is declared as an `actor` to guarantee that all
/// accesses to its mutable state are serialized, preventing data races in
/// concurrent environments.
public actor ReportRepositoryImpl: ReportRepository {
    
    @Injected(\.remoteDataSource) var dataSource: RemoteDataSource
    
    public init() {}
    
    /// Submits a report to the server with the given parameters.
    ///
    /// This method resolves the report endpoint from the module bundle, then
    /// sends a `POST` request with the provided parameters. The FCM registration
    /// token is attached to the request header via `NetworkInterceptor` so the
    /// server can associate the report with the sender's device.
    ///
    /// - Parameter params: A dictionary of report fields to include in the
    ///   JSON request body (e.g. category, description, target ID).
    ///
    /// - Throws:
    ///   - `NetworkError.invalidURL` if the report endpoint URL is absent or
    ///     malformed in the module bundle.
    ///   - Any networking or decoding error propagated from `RemoteDataSource`.
    public func register(params: [String : any Sendable]) async throws {
        guard let endpoint = Bundle.knData.reportURL else {
            throw NetworkError.invalidURL(message: "Invalid or missing report URL.")
        }
        
        try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: PostResponseDTO.self,
            useFCMToken: true
        )
    }
    
}
