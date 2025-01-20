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
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAttribute()
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
            self.titleLabel.text = item.title
            self.subTitleLabel.text = "[\(item.department)]  \(item.uploadDate)"
            
            self.titleLabel.isSkeletonable = true
            self.subTitleLabel.isSkeletonable = true
            
            self.titleLabel.showAnimatedSkeleton()
            self.subTitleLabel.showAnimatedSkeleton()
            
            self.isUserInteractionEnabled = false
        }
    }
    
    func configure(with item: MainNotice) {
        titleLabel.text = item.title
        subTitleLabel.text = "[\(item.department)]  \(item.uploadDate)"
        
        self.isUserInteractionEnabled = true
    }
    
    private func setupAttribute() {
        //for Title Label
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .accent
        
        //for Subtitle Label
        subTitleLabel.font = .preferredFont(forTextStyle: .caption2)
        subTitleLabel.textColor = .subTitle
    }
    
    private func setupLayout() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .mainCellBackground
        backgroundView.layer.cornerRadius = 10
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(subTitleLabel)
        contentView.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
