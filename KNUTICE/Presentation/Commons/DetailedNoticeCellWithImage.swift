//
//  GeneralNoticeCellWithImage.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/3/24.
//

import UIKit
import Kingfisher

final class DetailedNoticeCellWithImage: UITableViewCell {
    static let reuseIdentifier = "GeneralNoticeCellWithImage"
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let uploadDateLabel = UILabel()
    let image = UIImageView()
    var imageURL: String = "" {
        willSet {
            let processor = DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width * 0.4)) |>
                            CroppingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width * 0.4),
                                                   anchor: CGPoint(x: 0, y: 0))
            image.kf.indicatorType = .activity
            image.kf.setImage(with: URL(string: newValue), options: [.processor(processor)])
            image.layer.cornerRadius = 10
            image.clipsToBounds = true    //코너 라운드를 벗어나는 경우 잘라냄
        }
    }
    
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
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(uploadDateLabel)
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.height.equalTo(UIScreen.main.bounds.width * 0.4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
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
