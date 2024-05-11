//
//  MainListCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import UIKit
import SnapKit

final class MainListCell: UITableViewCell {
    static let reuseIdentifier = "MainListCell"
    
    let cellLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttribute() {
        cellLabel.font = .systemFont(ofSize: 17)
        cellLabel.textColor = .darkGray
        cellLabel.textAlignment = .left
    }
    
    private func setupLayout() {
        contentView.addSubview(cellLabel)
        cellLabel.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
