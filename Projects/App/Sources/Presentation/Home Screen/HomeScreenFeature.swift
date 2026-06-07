//
//  HomeScreenFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/6/26.
//

import ComposableArchitecture
import Factory
import Foundation
import KNDomain
import KNUtility

@Reducer
struct HomeScreenFeature: EntryTimeRecordable {
    @ObservableState
    struct State: Equatable {
        var sectionedNotices: LoadableState<[MainSectionNotice]> = .idle
        var majorNotices: LoadableState<MainSectionNotice> = .idle
    }
    
    enum Action {
        case onAppear
        case fetchAllContents
        case noticesResponse(LoadableState<[MainSectionNotice]>)
        case majorNoticesResponse(LoadableState<MainSectionNotice>)
    }
    
    @Injected(\.fetchTopThreeNoticesUseCase) private var fetchTopThreeNoticesUseCase
    @Injected(\.fetchNoticeSnapshotsUseCase) private var fetchNoticeSnapshotsUseCase
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let timeInterval = timeIntervalSinceLastEntry()
                
                if (state.sectionedNotices == .idle || state.majorNotices == .idle || timeInterval >= 1800) {
                    recordEntryTime()
                    return .send(.fetchAllContents)
                }
                
                return .none
                
            case .fetchAllContents:
                return .merge(
                    .run { send in
                        try Task.checkCancellation()
                        
                        for try await notices in fetchTopThreeNoticesUseCase.execute(isRefresh: false).values {
                            await send(.noticesResponse(.loaded(notices)))
                        }
                    } catch: { error, send in
                        await send(.noticesResponse(.error))
                    },
                    .run { send in
                        let majorStr = await MajorManager.shared.majorStrings.first ?? ""
                        let major = MajorCategory(rawValue: majorStr)
                        
                        guard let major else {
                            await send(.majorNoticesResponse(.empty))
                            return
                        }
                        
                        await send(.majorNoticesResponse(.loaded(MainSectionNotice.skeleton(header: major.localizedDescription, category: major))))
                        
                        try Task.checkCancellation()
                        
                        let snapshots = try await fetchNoticeSnapshotsUseCase.execute(category: major, size: 3)
                        let section = MainSectionNotice.from(snapshots: snapshots, category: major, header: major.localizedDescription)
                        await send(.majorNoticesResponse(.loaded(section)))
                    } catch: { error, send in
                        await send(.majorNoticesResponse(.error))
                    }
                )
                
            case let .noticesResponse(response):
                state.sectionedNotices = response
                return .none
                
            case let .majorNoticesResponse(response):
                state.majorNotices = response
                return .none
            }
        }
    }
}

extension MainSectionNotice {
    static func from(snapshots: [NoticeSnapshot], category: any CategoryProtocol, header: String) -> MainSectionNotice {
        let items = snapshots.map {
            MainNotice(presentationType: .actual, noticeSnapshot: $0)
        }
        return MainSectionNotice(header: header, category: category, items: items)
    }
    
    // TODO: AsyncStream UseCase로 변경
    static func skeleton(header: String, category: any CategoryProtocol, count: Int = 3) -> MainSectionNotice {
        let items = (0..<count).map { i in
            MainNotice(presentationType: .skeleton, noticeSnapshot: NoticeSnapshot(notice: Notice.skeletonNotices().first!, isNew: false))
        }
        return MainSectionNotice(header: header, category: category, items: items)
    }
}

