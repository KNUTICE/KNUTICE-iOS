//
//  BookmarkFormFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/16/25.
//

import ComposableArchitecture
import Foundation
import KNUTICECore

@Reducer
struct BookmarkFormFeature {
    @ObservableState
    struct State: Equatable {
        enum FormType {
            case create
            case update
        }
        
        @Presents var alert: AlertState<Action.Alert>?
        var bookmark: Bookmark
        var shouldDismiss: Bool = false
        let formType: FormType
                
        var isAlarmOn: Bool {
            get { bookmark.alarmDate != nil }
            set { bookmark.alarmDate = newValue ? Date() : nil }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case saveButtonTapped
        case cancelButtonTapped
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        case saveBookmarkResponse(Result<Void, any Error>)
        case disappear
        
        enum Delegate {
            case save(Bookmark)
            case switchToDetailMode
        }
        
        enum Alert {
            case saveCompleted
        }
    }
    
    enum CancelID {
        case saveBookmark
    }
    
    @Dependency(\.saveBookmarkUseCase) private var saveBookmarkUseCase
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                if case .update = state.formType {
                    return .send(.delegate(.save(state.bookmark)))
                } else {
                    return .run { [state] send in
                        try await saveBookmarkUseCase.execute(state.bookmark)
                        await send(.saveBookmarkResponse(.success(())))
                    } catch: { error, send in
                        await send(.saveBookmarkResponse(.failure(error)))
                    }
                    .cancellable(id: CancelID.saveBookmark, cancelInFlight: true)
                }
                
            case .cancelButtonTapped:
                if case .update = state.formType {
                    return .send(.delegate(.switchToDetailMode))
                } else {
                    state.shouldDismiss = true
                    return .none
                }
                
            case .binding:
                return .none
                
            case .delegate:
                return .none
                
            case .alert(.presented(.saveCompleted)):
                state.shouldDismiss = true
                return .none
                
            case .alert:
                return .none
                
            case .saveBookmarkResponse(.success):
                state.alert = AlertState {
                    TextState("알림")
                } actions: {
                    ButtonState(action: .saveCompleted) {
                        TextState("확인")
                    }
                } message: {
                    TextState("북마크 저장이 완료되었어요.")
                }
                return .none
                
            case let .saveBookmarkResponse(.failure(error)):
                if let error = error as? ExistingBookmarkError, case .alreadyExist(let message) = error {
                    state.alert = AlertState {
                        TextState("알림")
                    } message: {
                        TextState(message)
                    }
                } else {
                    state.alert = AlertState {
                        TextState("알림")
                    } message: {
                        TextState("북마크 저장에 실패했어요.\n잠시 후에 다시 시도해 보세요.")
                    }
                }
                return .none
                
            case .disappear:
                return .cancel(id: CancelID.saveBookmark)
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
