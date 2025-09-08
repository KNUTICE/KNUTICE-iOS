//
//  CompositionalLayoutConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import KNUTICECore
import UIKit
import RxRelay

//MARK: CompositionalLayoutConfigurable
@MainActor
protocol CompositionalLayoutConfigurable {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout
}

extension CompositionalLayoutConfigurable {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(UIDevice.current.userInterfaceIdiom == .phone ? 1.0 : 0.5),
            heightDimension: .estimated(500)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

//MARK: NoticeRepresentable
protocol NoticesRepresentable {
    var notices: BehaviorRelay<[Notice]> { get }
}
