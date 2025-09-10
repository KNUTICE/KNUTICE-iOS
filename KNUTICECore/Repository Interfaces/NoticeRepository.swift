//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import Combine

public protocol NoticeRepository: Sendable {
    /// Fetches a list of notices for the specified category with optional pagination and size.
    ///
    /// - Parameters:
    ///   - category: The category of notices to fetch. Must conform to `RawRepresentable` with `String` raw value (e.g., `NoticeCategory`, `MajorCategory`).
    ///   - after: An optional notice ID to fetch notices after (for pagination). Defaults to `nil`.
    ///   - size: The maximum number of notices to fetch. Defaults to `20`.
    ///
    /// - Returns: An `AnyPublisher` that emits an array of `Notice` objects:
    ///   - Contains the fetched notices if the request and decoding succeed.
    ///   - Emits an empty array if no notices are returned.
    ///   - Emits an `Error` if the request fails or decoding fails.
    ///
    /// - Note:
    ///   - Internally, this method decodes the response into `NoticeResponseDTO` and converts it into `[Notice]`.
    ///   - The publisher completes after emitting a single array of notices.
    func fetchNotices<T>(
        for category: T,
        after nttId: Int?,
        size: Int
    ) -> AnyPublisher<[Notice], Error> where T: RawRepresentable, T.RawValue == String
    
    /// Asynchronously fetches a list of notices for a given category.
    ///
    /// - Parameters:
    ///   - category: The notice category (must conform to `RawRepresentable` with `String` raw value)
    ///   - nttId: The notice ID to start fetching after (optional)
    ///   - size: The number of notices to fetch at once (default is 20)
    ///
    /// - Returns: An array of `Notice` objects
    /// - Throws: Throws an error if the network request fails or decoding fails
    ///
    /// **Example usage**:
    /// ```swift
    /// do {
    ///     let notices = try await fetchNotices(for: .generalNotice, size: 10)
    ///     print(notices)
    /// } catch {
    ///     print("Failed to fetch notices: \(error)")
    /// }
    /// ```
    func fetchNotices<T>(
        for category: T,
        after nttId: Int?,
        size: Int
    ) async throws -> [Notice] where T: RawRepresentable, T.RawValue == String
    
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
    func fetchNotices<T>(
        for category: T,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AnyPublisher<[Notice], Error> where T: RawRepresentable, T.RawValue == String {
        return self.fetchNotices(for: category, after: nttId, size: size)
    }
    
    func fetchNotices<T>(
        for category: T,
        after nttId: Int? = nil,
        size: Int = 20
    ) async throws -> [Notice] where T: RawRepresentable, T.RawValue == String {
        return try await self.fetchNotices(for: category, after: nttId, size: size)
    }
}
