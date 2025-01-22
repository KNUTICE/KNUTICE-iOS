//
//  BottomModal.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/20/25.
//

import UIKit

final class BottomModal: UIView {
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    private let closeBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "닫기"
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        let preferredFont = UIFont.preferredFont(forTextStyle: .title2)
        let boldFont = preferredFont.fontDescriptor.withSymbolicTraits(.traitBold)
        if let boldFont = boldFont {
            label.font = UIFont(descriptor: boldFont, size: 0)
        }
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.numberOfLines = 0    //멀티 라인으로 표시
        return label
    }()
    private let redirectBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "자세히 보기"
        config.baseBackgroundColor = .accent2
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let content: MainPopupContent
    
    init(content: MainPopupContent) {
        self.content = content
        super.init(frame: .zero)
        
        self.setAttribute()
        self.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        titleLabel.text = content.title
        contentLabel.text = content.content
    }
    
    func setLayout() {
        addSubview(contentView)
        addSubview(closeBtn)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(redirectBtn)
        
        self.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        //contentView
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-32)
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.4)
        }
        
        //closeBtn
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(contentView.snp.top).offset(-5)
        }
        
        //titleLabel
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.top.equalTo(contentView.snp.top).offset(16)
        }
        
        //redirectBtn
        redirectBtn.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        //contentLabel
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualTo(redirectBtn.snp.top).offset(-16)
        }
    }
    
    private func makeHidden() {
        self.removeFromSuperview()
        self.contentView.removeFromSuperview()
        self.closeBtn.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
    }
    
    @objc func closeBtnAction(_ sender: UIButton) {
        makeHidden()
    }
}
