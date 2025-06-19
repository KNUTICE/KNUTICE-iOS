//
//  NoticeCollectionViewCell.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import UIKit

final class NoticeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NoticeCollectionViewCell"
        private let titleLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .accent
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        private let subTitleLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .preferredFont(forTextStyle: .caption2)
            label.textColor = .subTitle
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        override var isHighlighted: Bool {
            didSet {
                guard self.isHighlighted else {
                    UIView.animate(withDuration: 0.05) {
                        self.backgroundColor = .clear
                    }
                    return
                }
                
                UIView.animate(withDuration: 0.05) {
                    self.backgroundColor = .cellHighlight
                }
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
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
            
            contentView.addSubview(subTitleLabel)
            subTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().offset(-20)
            }
        }
        
        func configure(with item: Notice) {
            titleLabel.text = item.title
            subTitleLabel.text = "[\(item.department)]  \(item.uploadDate)"
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            
            self.isHighlighted = false
        }
}
