//
//  NoticeTabItems.swift
//  KNCore
//
//  Created by 이정훈 on 4/13/26.
//

import Factory
import Foundation
import KNTopic
import KNUtility
import Observation
import RxRelay
import RxSwift

@MainActor
@Observable
final class NoticeTabItems {
    private(set) var categories: [CategoryItem] {
        didSet {
            categoriesRelay.accept(categories)
        }
    }
    
    @ObservationIgnored private let categoriesRelay: BehaviorRelay<[CategoryItem]>
    @ObservationIgnored private let disposeBag: DisposeBag = .init()
    @ObservationIgnored @Injected(\.updateTopicSubscriptionUseCase) private var updateTopicSubscriptionUseCase
    
    init(_ categoriesRelay: BehaviorRelay<[CategoryItem]>) {
        self.categoriesRelay = categoriesRelay
        self.categories = categoriesRelay.value
    }
    
    func insertAfterLastMajorCategory(newItem: CategoryItem) {
        let isAlreadyExists = categories.contains { $0.id == newItem.id }
        
        guard !isAlreadyExists else { return }
        
        let lastMajorIndex = categories.lastIndex { item in
            if case let .category(representable) = item {
                // 연관 값(representable)이 MajorCategory 타입인지 확인
                return representable is MajorCategory
            }
            return false
        }
        
        if let index = lastMajorIndex {
            categories.insert(newItem, at: index + 1)
        } else {
            categories.insert(newItem, at: 5)
        }
    }
    
    func activeTopic(of major: MajorCategory) async {
        do {
            try await updateTopicSubscriptionUseCase.execute(of: .major, topic: major, isEnabled: true)
            await MajorManager.shared.addMajor(major.rawValue)
        } catch {
            print(error)
        }
    }
    
    func deactiveTopic(of major: MajorCategory) async {
        do {
            try await updateTopicSubscriptionUseCase.execute(of: .major, topic: major, isEnabled: false)
            await MajorManager.shared.removeMajor(major.rawValue)
        } catch {
            print(error)
        }
    }
    
    func removeMajor(at indexSet: IndexSet) {
        let offset = NoticeCategory.allCases.count
        let adjustedIndices = IndexSet(indexSet.map { $0 + offset })    // categoriesRelay에는 앞에 5개의 추가적인 데이터가 존재
        categories.remove(atOffsets: adjustedIndices)
    }
}
