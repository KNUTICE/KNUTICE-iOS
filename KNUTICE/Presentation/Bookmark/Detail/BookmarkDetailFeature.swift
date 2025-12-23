//
//  BookmarkDetailFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/16/25.
//

import ComposableArchitecture
import KNUTICECore

@Reducer
struct BookmarkDetailFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        let bookmark: Bookmark
        var isShowingWebView: Bool = false
        var shouldDismiss: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case toggleWebView(Bool)
        case editButtonTapped
        case deleteButtonTapped
        case delegate(Delegate)
        case deleteBookmarkResponse(Result<Void, any Error>)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Delegate {
            case switchToEditMode
            case deleteBookmark
        }
        
        enum Alert: Equatable {
            case confirmDeletion
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .toggleWebView(isShowing):
                state.isShowingWebView = isShowing
                return .none
                
            case .editButtonTapped:
                return .send(.delegate(.switchToEditMode))
                
            case .deleteButtonTapped:
                return .send(.delegate(.deleteBookmark))
                
            case .delegate:
                return .none
            
            case .deleteBookmarkResponse(.success):
                state.alert = AlertState {
                    TextState("알림")
                } actions: {
                    ButtonState(action: .confirmDeletion) {
                        TextState("확인")
                    }
                } message: {
                    TextState("북마크 삭제를 완료했어요.")
                }
                return .none
                
            case .deleteBookmarkResponse(.failure):
                state.alert = AlertState {
                    TextState("알림")
                } message: {
                    TextState("현재 북마크를 삭제할 수 없어요.\n잠시 후 다시 시도해 주세요.")
                }
                return .none
                
            case .alert(.presented(.confirmDeletion)):
                state.shouldDismiss = true
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
}
