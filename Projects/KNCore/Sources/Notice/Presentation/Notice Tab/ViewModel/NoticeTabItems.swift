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
    
    private(set) var alertMessage: String = ""
    var isShowingAlert: Bool = false
    
    var selectedMajors: [MajorCategory] {
        categories.compactMap { item -> MajorCategory? in
            if case let .category(representable) = item,
               let major = representable as? MajorCategory {
                return major
            }
            return nil
        }
    }
    
    var isAddable: Bool {
        guard selectedMajors.count < 1 else {
            alertMessage = "선택되어 있는 전공 삭제 후 사용해주세요."
            isShowingAlert.toggle()
            return false
        }
        
        return true
    }
    
    @ObservationIgnored private let categoriesRelay: BehaviorRelay<[CategoryItem]>
    @ObservationIgnored private let disposeBag: DisposeBag = .init()
    @ObservationIgnored @Injected(\.updateTopicSubscriptionUseCase) private var updateTopicSubscriptionUseCase
    
    init(_ categoriesRelay: BehaviorRelay<[CategoryItem]>) {
        self.categoriesRelay = categoriesRelay
        self.categories = categoriesRelay.value
    }
    
    func availableMajors(for college: College) -> [MajorCategory] {
        college.majors.filter { major in
            !selectedMajors.contains(where: { $0 == major })
        }
    }
    
    
    // MARK: Add Major
    
    /// Inserts a new category item after the last existing `MajorCategory` in the list.
    /// If no `MajorCategory` exists, the item is inserted at index 5.
    /// Duplicate items are ignored.
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
    
    /// Activates the FCM topic subscription for the given major
    /// and registers it to `MajorManager`.
    func activeTopic(of major: MajorCategory) async {
        do {
            try await updateTopicSubscriptionUseCase.execute(of: .major, topic: major, isEnabled: true)
            await MajorManager.shared.addMajor(major.rawValue)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Delete Major
    
    /// Removes major categories at the specified index set.
    /// - Parameter indexSet: The indices relative to the `selectedMajors` list.
    ///   An offset equal to the number of `NoticeCategory` cases is applied internally
    ///   to map to the correct positions in `categories`.
    func removeMajor(at indexSet: IndexSet) {
        let offset = NoticeCategory.allCases.count
        let adjustedIndices = IndexSet(indexSet.map { $0 + offset })    // categoriesRelay에는 앞에 5개의 추가적인 데이터가 존재
        categories.remove(atOffsets: adjustedIndices)
    }
    
    /// Deactivates the FCM topic subscription for the given major
    /// and unregisters it from `MajorManager`.
    func deactiveTopic(of major: MajorCategory) async {
        do {
            try await updateTopicSubscriptionUseCase.execute(of: .major, topic: major, isEnabled: false)
            await MajorManager.shared.removeMajor(major.rawValue)
        } catch {
            print(error)
        }
    }
}
