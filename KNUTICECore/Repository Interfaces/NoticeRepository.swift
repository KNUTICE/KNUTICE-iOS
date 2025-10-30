//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Combine

public protocol NoticeRepository: Sendable {
    /// Fetches a list of notices from the server with optional filtering parameters.
    ///
    /// This method communicates with the remote `NoticeRepository` endpoint to retrieve
    /// a list of `Notice` objects. You can filter the results by category, keyword,
    /// and pagination options.
    ///
    /// - Parameters:
    ///   - category: An optional string representing the notice category (e.g., `"event"`, `"academic"`).
    ///   - keyword: An optional search keyword to filter notices.
    ///   - nttId: An optional ID of the last notice fetched, used for pagination.
    ///   - size: The number of notices to fetch per request. Defaults to `20`.
    ///
    /// - Returns: A publisher that emits an array of `Notice` objects on success,
    ///   or an `Error` if the request fails.
    func fetchNotices(
        for category: String?,
        keyword: String?,
        after nttId: Int?,
        size: Int
    ) -> AnyPublisher<[Notice], Error>
    
    /// Fetches a list of notices asynchronously with optional filtering parameters.
    ///
    /// This method wraps the Combine-based `fetchNotices` publisher
    /// and provides an async/await interface for convenience.
    /// You can filter the results by category, keyword, and pagination options.
    ///
    /// - Parameters:
    ///   - category: An optional string representing the notice category (e.g., `"event"`, `"academic"`).
    ///   - keyword: An optional search keyword to filter notices.
    ///   - nttId: An optional ID of the last notice fetched, used for pagination.
    ///   - size: The number of notices to fetch per request. Defaults to `20`.
    ///
    /// - Returns: An array of `Notice` objects fetched from the server.
    ///
    /// - Throws: An error if the request fails or if decoding the response is unsuccessful.
    func fetchNotices(
        for category: String?,
        keyword: String?,
        after nttId: Int?,
        size: Int
    ) async throws -> [Notice]
    
    /// Fetches multiple notices by their IDs.
    ///
    /// - Warning: **Deprecated**
    ///   - This method is deprecated and may be removed in future versions.
    ///   - Use `fetchNotices(by:)` or other supported methods instead.
    ///
    /// - Parameter nttIds: An array of notice IDs to fetch.
    /// - Returns: An `AnyPublisher` that emits an array of `Notice` objects
    ///            (skipping any failed lookups), or an `Error` if the request fails.
    ///
    /// - Note:
    ///   - Internally, this method merges multiple single-notice fetch publishers (`fetchNotice(by:)`)
    ///     into a single combined publisher.
    ///   - Any `nil` results will be filtered out using `compactMap`.
    @available(*, deprecated)
    func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error>
    
    /// Fetches a single notice by its ID as a Combine publisher.
    ///
    /// - Parameter nttId: The unique identifier of the notice to fetch.
    /// - Returns: An `AnyPublisher` that emits an optional `Notice`:
    ///   - A `Notice` if the request and decoding succeed and data exists.
    ///   - `nil` if the response contains no data for the given ID.
    ///   - An `Error` if the request fails or decoding fails.
    ///
    /// - Throws: This method does not throw directly, but the returned publisher
    ///           can emit errors of type `Error`.
    ///
    /// - Note:
    ///   - Internally, this method decodes the response into `SingleNoticeResponseDTO`
    ///     and converts it into a `Notice` model using `createNotice(_:)`.
    ///   - The publisher completes after emitting a single value.
    ///   - If `baseURL` is invalid or missing, the publisher immediately fails with
    ///     `NetworkError.invalidURL`.
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error>
    
    /// Fetches a single notice by its ID.
    ///
    /// - Parameter nttId: The unique identifier of the notice to fetch.
    /// - Returns: A `Notice` object if the notice exists, or `nil` if no data is returned.
    /// - Throws:
    ///   - `NetworkError.invalidURL` if the base URL is missing or invalid.
    ///   - Any error thrown by the underlying network request or decoding process.
    /// - Note:
    ///   - This method checks for task cancellation before performing the request.
    ///   - The response is decoded into `SingleNoticeResponseDTO` and then converted into a `Notice` model.
    func fetchNotice(by nttId: Int) async throws -> Notice?
}

public extension NoticeRepository {
    func fetchNotices(
        for category: String? = nil,
        keyword: String? = nil,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[Notice], Error> {
        return self.fetchNotices(for: category, keyword: keyword, after: nttId, size: size)
    }
    
    func fetchNotices(
        for category: String? = nil,
        keyword: String? = nil,
        after nttId: Int? = nil,
        size: Int = 20
    ) async throws -> [Notice] {
        return try await self.fetchNotices(for: category, keyword: keyword, after: nttId, size: size)
    }
}
