//
//  BookmarkDetailFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/16/25.
//

import ComposableArchitecture

@Reducer
public struct BookmarkDetailFeature: Sendable {
    
    @ObservableState
    public struct State: Equatable, Sendable {
        @Presents var alert: AlertState<Action.Alert>?
        var bookmark: Bookmark?
        let nttId: Int
        var isShowingWebView: Bool = false
        var shouldDismiss: Bool = false
        
        public init(alert: AlertState<Action.Alert>? = nil, bookmark: Bookmark? = nil, nttId: Int) {
            self.alert = alert
            self.bookmark = bookmark
            self.nttId = nttId
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case toggleWebView(Bool)
        case editButtonTapped
        case deleteButtonTapped
        case delegate(Delegate)
        case deleteBookmarkResponse(Result<Void, any Error>)
        case alert(PresentationAction<Alert>)
        case onAppear
        case onDisappear
        case bookmarkResponse(Result<Bookmark?, any Error>)
        
        @CasePathable
        public enum Delegate {
            case switchToEditMode
            case deleteBookmark
        }
        
        public enum Alert: Equatable, Sendable {
            case confirmDeletion
        }
    }
    
    public enum CancelID: Sendable {
        case fetchBookmark
    }
    
    @Dependency(\.fetchBookmarkUseCase) private var fetchBookmarkUseCase
    
    public var body: some ReducerOf<Self> {
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
                
            case let .bookmarkResponse(.success(bookmark)):
                state.bookmark = bookmark
                return .none
                
            case .bookmarkResponse(.failure(_)):
                return .none
                
            case .onAppear:
                guard let _ = state.bookmark else {
                    return .run { [id = state.nttId] send in
                        let bookmark = try await fetchBookmarkUseCase.execute(for: id)
                        await send(.bookmarkResponse(.success(bookmark)))
                    } catch: { error, send in
                        await send(.bookmarkResponse(.failure(error)))
                    }
                    .cancellable(id: CancelID.fetchBookmark)
                }
                
                return .none
                
            case .onDisappear:
                return .cancel(id: CancelID.fetchBookmark)
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
}
