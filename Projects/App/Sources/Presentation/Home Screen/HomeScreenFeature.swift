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
struct HomeScreenFeature {
    @ObservableState
    struct State: Equatable {
        var sectionedNotices: [MainSectionNotice] = []
        var majorNotices: MainSectionNotice? = nil
    }
    
    enum Action {
        case onAppear
        case noticesResponse([MainSectionNotice])
        case majorNoticesResponse(MainSectionNotice)
    }
    
    @Injected(\.fetchTopThreeNoticesUseCase) private var fetchTopThreeNoticesUseCase
    @Injected(\.fetchNoticesUseCase) private var fetchNoticesUseCase
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
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
                            // TODO: 선택된 전공이 없으면 Default 화면 표시 하도록 수정
                            return
                        }
                        
                        try Task.checkCancellation()
                        
                        let notices = try await fetchNoticesUseCase.execute(category: major, size: 3)
                        let section = MainSectionNotice.from(notices: notices, header: major.localizedDescription)
                        await send(.majorNoticesResponse(section))
                    } catch: { error, send in
                        
                    }
                )
                
            case let .noticesResponse(notices):
                state.sectionedNotices = notices
                return .none
                
            case let .majorNoticesResponse(notices):
                state.majorNotices = notices
                return .none
            }
        }
    }
}

extension MainSectionNotice {
    static func from(notices: [Notice], header: String) -> MainSectionNotice {
        let items = notices.map { notice in
            MainNotice(
                presentationType: .actual,
                notice: notice
            )
        }
        return MainSectionNotice(header: header, items: items)
    }
}

