//
//  CompositionalLayoutConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import UIKit
import RxRelay

//MARK: CompositionalLayoutConfigurable
@MainActor
public protocol CompositionalLayoutConfigurable {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout
}

public extension CompositionalLayoutConfigurable {
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
