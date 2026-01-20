//
//  ReportFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/12/25.
//

import ComposableArchitecture

@Reducer
public struct ReportFeature {
    
    @ObservableState
    public struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var content: String = ""
        var isLoading: Bool = false
        var shouldDismiss: Bool = false
        
        public init() {}
    }

    @CasePathable
    public enum Action: BindableAction {
        // Binding Actions
        case binding(BindingAction<State>)
        
        // User View Actions
        case submitButtonTapped(device: String)
        
        // Internal/Effect Actions
        case submitResponse(Result<Void, Error>)
        
        // Navigation/Presentation Actions
        case alert(PresentationAction<Alert>)
        
        case disappear
        
        public enum Alert: Equatable {
            case reportSubmitted
        }
    }
    
    enum CancelID {
        case submitReport
    }
    
    @Dependency(\.submitReportUseCase) private var submitReportUseCase
    
    public init() {}

    public var body: some Reducer<State, Action> {
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
                .cancellable(id: CancelID.submitReport, cancelInFlight: true)
                
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
                
            case .disappear:
                return .cancel(id: CancelID.submitReport)
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
}
