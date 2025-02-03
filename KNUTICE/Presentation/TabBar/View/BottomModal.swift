//
//  BottomModal.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/20/25.
//

import UIKit
import SwiftUI

final class BottomModal: UIView {
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    private let closeBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 15)
        config.attributedTitle = AttributedString("닫기", attributes: titleContainer)
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    private let dontShowForTodayBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 15)
        config.attributedTitle = AttributedString("오늘 하루 보지 않기", attributes: titleContainer)
        config.image = UIImage(systemName: "checkmark")
        config.imagePadding = 5
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10)
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(dontShowBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.numberOfLines = 0    //멀티 라인으로 표시
        return label
    }()
    private let redirectBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 17)
        config.attributedTitle = AttributedString("자세히 보기", attributes: titleContainer)
        config.baseBackgroundColor = .accent2
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(redirectBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let content: MainPopupContent
    
    init(content: MainPopupContent) {
        self.content = content
        super.init(frame: .zero)
        
        self.setAttribute()
        self.backgroundColor = .black.withAlphaComponent(0.7)
        self.alpha = 0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        titleLabel.text = content.title
        
        let attributedText = NSMutableAttributedString(string: content.content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        contentLabel.attributedText = attributedText
    }
    
    func setupLayout() {
        addSubview(contentView)
        addSubview(closeBtn)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(redirectBtn)
        addSubview(dontShowForTodayBtn)
        
        self.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        //contentView
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(UIScreen.main.bounds.size.width * 0.8)
        }
        
        //closeBtn
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(contentView.snp.top).offset(-5)
        }
        
        //dontShowForTodayBtn
        dontShowForTodayBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
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
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeFromSuperview()
            self.contentView.removeFromSuperview()
            self.closeBtn.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
        }
    }
    
    @objc private func closeBtnAction(_ sender: UIButton) {
        makeHidden()
    }
    
    @objc private func redirectBtnAction(_ sender: UIButton) {
        func getViewController() -> UIViewController? {
            var responder: UIResponder? = self
            
            while responder != nil {
                responder = responder?.next
                if let viewController = responder as? UIViewController {
                    return viewController
                }
            }
            
            return nil
        }
        
        let viewController = UIHostingController(rootView: ContentWebView(navigationTitle: "", contentURL: content.contentURL))
        getViewController()?.navigationController?.pushViewController(viewController, animated: true)
        makeHidden()    //navigation 이동 전 View 삭제
    }
    
    @objc private func dontShowBtnAction(_ sender: UIButton) {
        guard let endOfToday = Date.endOfToday else { return }
        UserDefaults.standard.set(endOfToday.timeIntervalSince1970, forKey: "noShowPopupDate")
        makeHidden()
    }
}
