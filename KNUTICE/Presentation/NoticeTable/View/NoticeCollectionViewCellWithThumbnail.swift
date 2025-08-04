//
//  NoticeCollectionViewCellWithThumbnail.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import UIKit
import Kingfisher

final class NoticeCollectionViewCellWithThumbnail: UICollectionViewCell {
    static var reuseIdentifier: String {
        "NoticeCollectionViewCellWithThumbnail"
    }
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .accent
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .subTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let image: UIImageView = UIImageView(frame: .zero)
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
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(image.snp.width).multipliedBy(0.4)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with item: Notice) {
        titleLabel.text = item.title
        subTitleLabel.text = "[\(item.department)]  \(item.uploadDate)"
        
        if let imageURL = item.imageUrl {
            self.imageURL = imageURL
        } else {
            self.imageURL = Bundle.main.defaultThumbnailURL
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var backgroundConfiguration = UIBackgroundConfiguration.clear()
        backgroundConfiguration.backgroundColor = state.isHighlighted ? .cellHighlight : .clear
        self.backgroundConfiguration = backgroundConfiguration
    }
}
