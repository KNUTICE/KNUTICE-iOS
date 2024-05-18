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
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .black
        
        //for Subtitle Label
        subTitleLabel.font = .systemFont(ofSize: 12)
        subTitleLabel.textColor = .darkGray
        
        //for UploadDate Label
        uploadDateLabel.font = .systemFont(ofSize: 12)
        uploadDateLabel.textColor = .darkGray
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(uploadDateLabel)
        
        //constraint
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        uploadDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(subTitleLabel.snp.trailing).offset(5)
        }
    }
}
