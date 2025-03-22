//
//  MainTableViewCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    class var reuseIdentifier: String {
        "MainTableViewCell"
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .accent
        
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .subTitle
        
        return label
    }()
    let cellBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .mainCellBackground
        backgroundView.layer.cornerRadius = 10
        
        return backgroundView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: MainNotice) {
        titleLabel.text = item.notice.title
        subTitleLabel.text = "[\(item.notice.department)]  \(item.notice.uploadDate)"
    }
    
    func setupLayout() {
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cellBackgroundView.snp.top).offset(16)
            make.leading.equalTo(cellBackgroundView.snp.leading).offset(16)
            make.trailing.equalTo(cellBackgroundView.snp.trailing).offset(-16)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(cellBackgroundView.snp.leading).offset(16)
            make.trailing.equalTo(cellBackgroundView.snp.trailing).offset(-16)
            make.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-16)
        }
    }
}
