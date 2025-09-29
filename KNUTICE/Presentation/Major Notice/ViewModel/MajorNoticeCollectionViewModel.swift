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

    init() {
        let majorStr = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedMajor.rawValue)
        selectedMajor = MajorCategory(rawValue: majorStr ?? "")
        
        super.init(category: MajorCategory(rawValue: majorStr ?? ""))
    }
}
