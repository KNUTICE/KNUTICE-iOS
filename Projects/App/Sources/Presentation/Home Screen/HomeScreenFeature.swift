//
//  HomeScreenFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/6/26.
//

import ComposableArchitecture
import Factory
import Foundation
import KNCore
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
        case noticesResponse([MainSectionNotice])
        case majorNoticesResponse(LoadableState<MainSectionNotice>)
    }
    
    @Injected(\.fetchTopThreeNoticesUseCase) private var fetchTopThreeNoticesUseCase
    @Injected(\.fetchNoticesUseCase) private var fetchNoticesUseCase
    
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
                            await send(.noticesResponse(notices))
                        }
                    } catch: { error, send in
                        
                    },
                    .run { send in
                        let majorStr = UserDefaults.shared?.string(forKey: UserDefaultsKeys.selectedMajor.rawValue) ?? ""
                        let major = MajorCategory(rawValue: majorStr)
                        
                        guard let major else {
                            await send(.majorNoticesResponse(.empty))
                            return
                        }
                        
                        try Task.checkCancellation()
                        
                        await send(.majorNoticesResponse(.loaded(MainSectionNotice.skeleton(category: major))))
                        let notices = try await fetchNoticesUseCase.execute(category: major, size: 3)
                        let section = MainSectionNotice.from(notices: notices, category: major, header: major.localizedDescription)
                        await send(.majorNoticesResponse(.loaded(section)))
                    } catch: { error, send in
                        
                    }
                )
                
            case let .noticesResponse(notices):
                state.sectionedNotices = .loaded(notices)
                return .none
                
            case let .majorNoticesResponse(notices):
                state.majorNotices = notices
                return .none
            }
        }
    }
}

extension MainSectionNotice {
    static func from(notices: [Notice], category: any CategoryProtocol, header: String) -> MainSectionNotice {
        let items = notices.map { notice in
            MainNotice(
                presentationType: .actual,
                notice: notice
            )
        }
        return MainSectionNotice(header: header, category: category, items: items)
    }
    
    static func skeleton(header: String = "skeleton header", category: any CategoryProtocol, count: Int = 3) -> MainSectionNotice {
        let items = (0..<count).map { i in
            MainNotice(
                presentationType: .skeleton,
                notice: Notice.skeletonNotices().first!
            )
        }
        return MainSectionNotice(header: header, category: category, items: items)
    }
}

