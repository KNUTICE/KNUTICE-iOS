//
//  GeneralNoticeCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/2/24.
//

import UIKit
import SnapKit

final class DetailedNoticeCell: UITableViewCell {
    static let reuseIdentifier = "GeneralNoticeCell"
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let uploadDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttribute() {
        //for Title Label
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .accent
        
        //for Subtitle Label
        subTitleLabel.font = .preferredFont(forTextStyle: .caption2)
        subTitleLabel.textColor = .subTitle
        
        //for UploadDate Label
        uploadDateLabel.font = .preferredFont(forTextStyle: .caption2)
        uploadDateLabel.textColor = .subTitle
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(uploadDateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        uploadDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(subTitleLabel.snp.trailing).offset(5)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = highlighted ? .cellHighlight : .customBackground
    }
}
