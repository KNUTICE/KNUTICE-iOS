//
//  MainTableViewCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import UIKit
import SnapKit

final class MainTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MainListCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .accent
        
        return label
    }()
    private let subTitleLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .subTitle
        
        return label
    }()
    private let cellBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .mainCellBackground
        backgroundView.layer.cornerRadius = 10
        
        return backgroundView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.hideSkeleton()
        subTitleLabel.hideSkeleton()
        isUserInteractionEnabled = true
    }
    
    func configureSkeleton(with item: MainNotice) {
        DispatchQueue.main.async {
            self.titleLabel.text = item.notice.title
            self.subTitleLabel.text = "[\(item.notice.department)]  \(item.notice.uploadDate)"
            
            self.titleLabel.isSkeletonable = true
            self.subTitleLabel.isSkeletonable = true
            
            self.titleLabel.showAnimatedSkeleton()
            self.subTitleLabel.showAnimatedSkeleton()
            
            self.isUserInteractionEnabled = false
        }
    }
    
    func configure(with item: MainNotice) {
        titleLabel.text = item.notice.title
        subTitleLabel.text = "[\(item.notice.department)]  \(item.notice.uploadDate)"
        
        self.isUserInteractionEnabled = true
    }
    
    private func setupLayout() {
        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        cellBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cellBackgroundView.snp.top).offset(16)
            make.leading.equalTo(cellBackgroundView.snp.leading).offset(16)
            make.trailing.equalTo(cellBackgroundView.snp.trailing).offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(cellBackgroundView.snp.leading).offset(16)
            make.trailing.equalTo(cellBackgroundView.snp.trailing).offset(-16)
            make.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-16)
        }
    }
}
