//
//  ReportViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/21/24.
//

import Combine
import Foundation
import Factory

final class ReportViewModel: ObservableObject {
    enum AlertType {
        case success
        case failure
        case textOverFlow
        case none
    }
    
    @Published var content: String = ""
    @Published var isShowingAlert: Bool = false
    @Published var isLoading: Bool = false
    
    @Injected(\.reportService) private var reportService: ReportService
    private var cancellables = Set<AnyCancellable>()
    private(set) var alertType: AlertType = .none
    private(set) var alertMessage: String = ""
    
    func report(device: String) {
        guard 500 >= content.count else {
            alertType = .textOverFlow
            alertMessage = "본문은 500자 이내로 가능합니다."
            isShowingAlert.toggle()
            return
        }
        
        isLoading.toggle()
        reportService.report(content: content, device: device)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading.toggle()
                switch completion {
                case .finished:
                    print("The request to report has been completed")
                    self?.alertType = .success
                case .failure(let error):
                    print("ReportViewModel.report: \(error)")
                    self?.handleError(error)
                    self?.alertType = .failure
                }
                self?.isShowingAlert.toggle()
            }, receiveValue: { _ in
                //Nothing todo
            })
            .store(in: &cancellables)
    }
    
    private func handleError(_ error : Error) {
        if let error = error as? RemoteServerError, case .invalidResponse(let message) = error {
            alertMessage = message
        } else {
            alertMessage = "제출에 실패 했어요.\n잠시후 다시 시도해 주세요."
        }
    }
}
