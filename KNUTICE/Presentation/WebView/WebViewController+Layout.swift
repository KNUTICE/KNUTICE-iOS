//
//  WebViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import UIKit

extension WebViewController {
    func loadPage(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
    
    func setupAttribute() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never    //navigation inline title
        
        //webView
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.isHidden = true
        
        //progressView
        progressView.progressTintColor = .accent2
        
        //reminderSheetBtn
        let plusImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        reminderSheetBtn.setImage(plusImage, for: .normal)
        reminderSheetBtn.setImage(plusImage, for: .highlighted)
        reminderSheetBtn.tintColor = .white
        reminderSheetBtn.backgroundColor = .accent2
        reminderSheetBtn.layer.cornerRadius = 25
        reminderSheetBtn.layer.masksToBounds = false
        reminderSheetBtn.layer.shadowColor = UIColor.black.cgColor
        reminderSheetBtn.layer.shadowOpacity = 0.3
        reminderSheetBtn.layer.shadowRadius = 7
        reminderSheetBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        reminderSheetBtn.addTarget(self, action: #selector(openReminderForm(_:)), for: .touchUpInside)
    }
    
    func setupLayout() {
        view.backgroundColor = .customBackground
        
        //progressView
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        //webView
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        //reminderSheetBtn
        view.addSubview(reminderSheetBtn)
        reminderSheetBtn.translatesAutoresizingMaskIntoConstraints = false
        reminderSheetBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    func setupNavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(openSharePanel))
    }
}
