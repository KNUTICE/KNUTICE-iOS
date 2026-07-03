//
//  NoticeSectionModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/25.
//

import KNDomain
import RxDataSources

/// A section model that groups notice snapshots for RxDataSources-backed views.
public struct NoticeSectionModel {
    /// The notice items displayed in this section.
    public var items: [Item]
    
    /// Creates a section model with the given notice snapshots.
    ///
    /// - Parameter items: The notice snapshots to display in the section.
    public init(items: [NoticeSnapshot]) {
        self.items = items
    }
}

extension NoticeSectionModel: AnimatableSectionModelType {
    public typealias Item = NoticeSnapshot
    public typealias Identity = Int
    
    /// A stable section identity used by RxDataSources diffing.
    public var identity: Int { return 0 }
    
    /// Creates a copy of an existing section model with updated items.
    ///
    /// - Parameters:
    ///   - original: The existing section model to copy.
    ///   - items: The replacement notice snapshots for the section.
    public init(original: NoticeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: - RxDataSources Conformance

// NOTE: This extension is implemented in the UI layer rather than the Domain layer
// to prevent the Domain from depending on UI-specific frameworks (RxDataSources).
// The `@retroactive` attribute is used to suppress compiler warnings while
// retroactively conforming a Domain model to a UI-layer protocol.
extension NoticeSnapshot: @retroactive IdentifiableType {
    public typealias Identity = Int
    
    public var identity: Int { return id }
}
