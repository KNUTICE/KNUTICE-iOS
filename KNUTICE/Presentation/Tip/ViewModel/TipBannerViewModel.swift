//
//  TipBannerViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/1/25.
//

import Combine
import Factory
import Foundation
import os

@MainActor
final class TipBannerViewModel: ObservableObject {
    @Published var tips: [Tip]? = nil
    @Published var selectedIndex: Int = 0
    
    @Injected(\.TipRepository) private var repository
    private let logger: Logger = Logger()
    var selectedURL: String = ""
    var task: Task<Void, Never>?
    
    func fetchTips() async {
        let result = await repository.fetchTips()
        
        guard !Task.isCancelled else { return }
        
        switch result {
        case .success(let tips):
            if let tips {
                NotificationCenter.default.post(name: Notification.Name.hasTipData, object: nil)
                self.tips = tips
            }
        case .failure(let error):
            logger.error("\(error.localizedDescription)")
        }
    }
    
    func timer() {
        task = Task {
            while true {
                try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)    //5초
                
                guard !Task.isCancelled else { break }
                
                if let count = tips?.count, selectedIndex == count - 1 {
                    selectedIndex = 0
                } else {
                    selectedIndex += 1
                }
            }
        }
    }
}
