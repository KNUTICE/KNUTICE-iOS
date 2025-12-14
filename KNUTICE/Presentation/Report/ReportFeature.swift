//
//  ReportFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/12/25.
//

import ComposableArchitecture

@Reducer
struct ReportFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var content: String = ""
        var isLoading: Bool = false
        var shouldDismiss: Bool = false
    }

    @CasePathable
    enum Action: BindableAction {
        // Binding Actions
        case binding(BindingAction<State>)
        
        // User View Actions
        case submitButtonTapped(device: String)
        
        // Internal/Effect Actions
        case submitResponse(Result<Void, Error>)
        
        // Navigation/Presentation Actions
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case reportSubmitted
        }
    }
    
    @Dependency(\.submitReportUseCase) private var submitReportUseCase

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            // MARK: - Binding                
            case .binding:
                return .none
                
            // MARK: - User Actions
            case let .submitButtonTapped(device):
                state.isLoading = true
                return .run { [content = state.content] send in
                    do {
                        try await submitReportUseCase.execute(content: content, device: device)
                        await send(.submitResponse(.success(())))
                    } catch {
                        await send(.submitResponse(.failure(error)))
                    }
                }
                
            // MARK: - Internal Actions
            case .submitResponse(.success):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("알림")
                } actions: {
                    ButtonState(action: .reportSubmitted) {
                        TextState("확인")
                    }
                } message: {
                    TextState("제출을 완료했어요.")
                }
                return .none
                
            case let .submitResponse(.failure(error)):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("알림")
                } message: {
                    TextState(error.localizedDescription)
                }
                return .none
                
            // MARK: - Navigation & Alert
            case .alert(.presented(.reportSubmitted)):
                state.shouldDismiss.toggle()
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
}
