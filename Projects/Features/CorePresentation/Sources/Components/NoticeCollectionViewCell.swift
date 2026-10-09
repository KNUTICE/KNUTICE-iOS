//
//  NoticeCollectionViewCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import KNDomain
import UIKit
import Kingfisher
import KNDesignSystem
import SnapKit

public final class NoticeCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier = "NoticeCollectionViewCell"
    
    private let newBadgeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "N"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constants.newBadgeFontSize, weight: .bold)
        label.backgroundColor = KNDesignSystemAsset.accent2.color
        label.textAlignment = .center
        label.layer.cornerRadius = Constants.newBadgeCornerRadius
        label.clipsToBounds = true
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .font(for: .footnote, weight: .bold)
        
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            newBadgeLabel,
            titleLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        
        return stackView
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = KNDesignSystemAsset.subTitle.color
        
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            thumbnailImageView,
            titleStackView,
            subTitleLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        contentView.addSubview(stackView)
        
        newBadgeLabel.snp.makeConstraints {
            $0.width.height.equalTo(Constants.newBadgeFrameSize)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.56)
        }
        
        stackView.setCustomSpacing(16, after: thumbnailImageView)    // 썸네일 이미지와 타이틀 사이 공간을 16으로 설정
    }
    
    func configure(
        with item: NoticeSnapshot,
        isShowingThumbnail: Bool
    ) {
        titleLabel.text = item.notice.title
        subTitleLabel.text = "[\(item.notice.department ?? "")] \(item.notice.uploadDate)"

        // New Badge
        newBadgeLabel.isHidden = !item.isNew
        
        // Thumbnail
        thumbnailImageView.kf.cancelDownloadTask()
        
        guard isShowingThumbnail else {
            thumbnailImageView.isHidden = true
            thumbnailImageView.image = nil
            return
        }

        let width = bounds.width
        let height = width * 0.56
        let scale = traitCollection.displayScale
        let targetSize = CGSize(
            width: width * scale,
            height: height * scale
        )
        let processor =
        DownsamplingImageProcessor(size: targetSize) |>
        CroppingImageProcessor(
            size: targetSize,
            anchor: CGPoint(x: 0.5, y: 0)
        )
        
        thumbnailImageView.isHidden = false
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(
            with: URL(string: item.notice.imageURL ?? CorePresentationResources.bundle.defaultThumbnailURL),
            options: [
                .processor(processor)
            ]
        )
    }
    
    public override func updateConfiguration(using state: UICellConfigurationState) {
        var backgroundConfiguration = UIBackgroundConfiguration.clear()
        backgroundConfiguration.backgroundColor = state.isHighlighted ? KNDesignSystemAsset.cellHighlight.color : .clear
        self.backgroundConfiguration = backgroundConfiguration
    }
}
