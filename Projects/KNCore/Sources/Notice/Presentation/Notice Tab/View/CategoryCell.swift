//
//  CategoryCell.swift
//  KNCore
//
//  Created by 이정훈 on 4/10/26.
//

import KNDesignSystem
import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier: String = "CategoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance(isSelected: isSelected)
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        // 초기 디자인 (비선택 상태)
        updateAppearance(isSelected: false)
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func updateAppearance(isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = KNDesignSystemAsset.accent2.color
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = KNDesignSystemAsset.mainCellBackground.color
            titleLabel.textColor = KNDesignSystemAsset.gray4.color
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
