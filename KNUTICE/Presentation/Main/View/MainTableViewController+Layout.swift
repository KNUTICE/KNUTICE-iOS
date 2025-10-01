//
//  MainViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import UIKit
import SwiftUI

//MARK: - Layout
extension MainTableViewController {
    func setupLayout() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            view.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            }
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            if UIDevice.current.userInterfaceIdiom == .phone {
                make.top.equalTo(stackView.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        tableView.tableHeaderView = tipView
    }
    
    func createNavigationItems() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingBtn)
        }
    }
    
    func createSectionHeader(for section: Int) -> UIView {
        let headerColors: [UIColor] = [.accentOrange, .accentAmber, .accentMint, .accentBlue, .accentPurple]
        let headerView = UIView()
        let title: UILabel = {
            let label = UILabel()
            label.text = viewModel.cellValues[section].header
            label.textColor = headerColors[section]
            label.font = UIFont.font(for: .title3, weight: .bold)
            
            return label
        }()
        let button: UIButton = {
            let arrowImage = UIImage(systemName: "chevron.right")
            let targetSize = CGSize(width: 8, height: 12)
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let resizedImage = renderer.image { context in
                arrowImage?.draw(in: CGRect(origin: .zero, size: targetSize))
            }
            
            let button = UIButton(type: .system)
            button.setTitle("더보기", for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
            button.tintColor = .grayButton
            button.setImage(resizedImage, for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            button.tag = section
            button.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
            
            return button
        }()
        
        headerView.addSubview(title)
        headerView.addSubview(button)
        
        //Auto Layout
        title.snp.makeConstraints { make in
            make.leading.equalTo(headerView.safeAreaLayoutGuide).inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalTo(headerView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
}
