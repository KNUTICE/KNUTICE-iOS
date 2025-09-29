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
final class MajorNoticeCollectionViewModel: NoticeCollectionViewModel<MajorCategory>, ObservableObject {
    @Published var selectedMajor: MajorCategory?
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let majorStr = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedMajor.rawValue)
        selectedMajor = MajorCategory(rawValue: majorStr ?? "")
        
        super.init(category: MajorCategory(rawValue: majorStr ?? ""))
    }
    
    /// Observes changes to `selectedMajor`, updates the notice category, and persists the selection to UserDefaults.
    func bindSelectedMajor() {
        $selectedMajor
            .sink(receiveValue: { [weak self] selectedMajor in
                guard let selectedMajor else { return }
                
                // 공지 카테고리를 수정하면 프로퍼티 옵저버에 의해 자동으로 데이터 업데이드
                self?.updateSelectedMajor(selectedMajor)
                // UserDefaults에 새로 선택된 공지 카테고리 저장
                UserDefaults.standard.set(selectedMajor.rawValue, forKey: UserDefaultsKeys.selectedMajor.rawValue)
            })
            .store(in: &cancellables)
    }
}
