//
//  MajorNoticeCollectionViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/26/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore
import RxRelay

@MainActor
final class MajorNoticeCollectionViewModel: ObservableObject, NoticeSectionModelProvidable {
    @Published var selectedMajor: MajorCategory?
    let notices: BehaviorRelay<[NoticeSectionModel]> = .init(value: [])
    
    @Injected(\.noticeRepository) private var repository
    private(set) var task: Task<Void, Never>?
    
    init() {
        let majorStr = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedMajor.rawValue)
        
        if let majorStr {
            selectedMajor = MajorCategory(rawValue: majorStr)
        }
    }
    
    func fetchNotices() {
        task = Task {
            do {
                let notices = try await repository.fetchNotices(for: selectedMajor?.rawValue)
                let noticeSectionModel = NoticeSectionModel(items: notices)
                
                self.notices.accept([noticeSectionModel])
            } catch {
                print(error)
            }
        }
    }
}
