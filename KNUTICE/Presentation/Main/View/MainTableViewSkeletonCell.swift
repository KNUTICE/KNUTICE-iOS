//
//  MainTableViewSkeletonCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/22/25.
//

import UIKit

final class MainTableViewSkeletonCell: MainTableViewCell {
    override class var reuseIdentifier: String {
        "MainTablewViewSkeletonCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with item: MainNotice) {
        titleLabel.text = item.notice.title
        subTitleLabel.text = item.notice.department
        isUserInteractionEnabled = false
        
        DispatchQueue.main.async {
            self.titleLabel.isSkeletonable = true
            self.titleLabel.showAnimatedSkeleton()
            
            self.subTitleLabel.isSkeletonable = true
            self.subTitleLabel.showAnimatedSkeleton()
        }
    }
}
