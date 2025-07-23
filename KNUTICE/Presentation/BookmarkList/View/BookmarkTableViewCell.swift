//
//  BookmarkTableViewCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import UIKit

final class BookmarkTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BookmarkTableViewCell"
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    let alarmImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "alarm"))
        imageView.tintColor = .gray
        
        return imageView
    }()
    let alarmDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .gray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(alarmImageView)
        alarmImageView.snp.makeConstraints { make in
            make.width.equalTo(14)
            make.height.equalTo(15)
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(alarmDateLabel)
        alarmDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(alarmImageView.snp.trailing).offset(5)
            make.centerY.equalTo(alarmImageView.snp.centerY)
            
        }
    }

    func configure(_ bookmark: Bookmark) {
        titleLabel.text = bookmark.notice.title
        alarmDateLabel.text = bookmark.alarmDate?.dateTime ?? "없음"
    }

}
