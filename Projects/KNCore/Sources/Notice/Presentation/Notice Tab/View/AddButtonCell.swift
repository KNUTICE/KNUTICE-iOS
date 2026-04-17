//
//  AddButtonCell.swift
//  KNCore
//
//  Created by 이정훈 on 4/10/26.
//

import RxSwift
import UIKit
import SnapKit

final class AddButtonCell: UICollectionViewCell {
    static let reuseIdentifier = "AddButtonCell"
    
    private let actionButton: UIButton = {
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        config.image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        config.baseBackgroundColor = .systemGray6
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        config.background.cornerRadius = 16
        
        let button = UIButton(configuration: config)
        return button
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAction(_ action: @escaping () -> Void) {
        actionButton.removeTarget(nil, action: nil, for: .touchUpInside)
        actionButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
    }
}
