//
//  ReportViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/21/24.
//

import Combine
import Foundation

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
    
    var alertType: AlertType = .none
    private let reportService: ReportService
    private var cancellables = Set<AnyCancellable>()
    
    init(reportService: ReportService) {
        self.reportService = reportService
    }
    
    func report(device: String) {
        guard 500 >= content.count else {
            alertType = .textOverFlow
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
                case .failure(let error):
                    print("ReportViewModel.report: \(error)")
                    self?.alertType = .failure
                    self?.isShowingAlert.toggle()
                }
            }, receiveValue: { [weak self] in
                if $0 {
                    self?.alertType = .success
                } else {
                    self?.alertType = .failure
                }
                
                self?.isShowingAlert.toggle()
            })
            .store(in: &cancellables)
    }
}
