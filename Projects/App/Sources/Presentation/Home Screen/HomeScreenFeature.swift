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
    @Injected(\.fetchNoticeSnapshotsWithSkeletonUseCase) private var fetchNoticeSnapshotsWithSkeletonUseCase
    
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
                        
                        for try await notices in fetchTopThreeNoticesUseCase.execute().values {
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
                        
                        for try await notices in fetchNoticeSnapshotsWithSkeletonUseCase.execute(category: major, size: 3) {
                            await send(.majorNoticesResponse(.loaded(notices)))
                        }
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

