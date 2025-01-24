//
//  MainViewController+Layout.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import UIKit
import SwiftUI

//MARK: - Layout
extension MainViewController {
    func setupAttribute() {
        //tableView
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 15    //header padding
        tableView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.reuseIdentifier)
        tableView.rowHeight = 95        
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .mainBackground
        
        //Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "KNUTICE"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        
        //button
        let targetSize = CGSize(width: 25, height: 24)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let gearImage = UIImage(systemName: "gearshape")
        let selectedGearImage = UIImage(systemName: "gearshape")?.withTintColor(.lightGray)
        let resizedGearImage = renderer.image { _ in
            gearImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }.withTintColor(.navigationButton)
        let resizedSelectedGearImage = renderer.image { _ in
            selectedGearImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        let magnifyingglassImage = UIImage(systemName: "magnifyingglass")
        let selectedMagnifyingglassImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray)
        let resizedMagnifyingglassImage = renderer.image { _ in
            magnifyingglassImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }.withTintColor(.navigationButton)
        let resizedSelectedMagnifyingglassImage = renderer.image { _ in
            selectedMagnifyingglassImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
        settingBtn.setImage(resizedGearImage, for: .normal)
        settingBtn.setImage(resizedSelectedGearImage, for: .highlighted)
        settingBtn.addTarget(self, action: #selector(navigateToSetting(_:)), for: .touchUpInside)
        
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.setImage(resizedMagnifyingglassImage, for: .normal)
        searchBtn.setImage(resizedSelectedMagnifyingglassImage, for: .highlighted)
        searchBtn.addTarget(self, action: #selector(navigateToSearch(_:)), for: .touchUpInside)
        
        //view
        view.backgroundColor = .mainBackground
    }
    
    func setupLayout() {
        navigationBar.addSubview(titleLabel)
        navigationBar.addSubview(settingBtn)
        navigationBar.addSubview(searchBtn)
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        
        //navigationBar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        //titleLabel
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(navigationBar.snp.left).offset(16)
        }
        
        //settingBtn
        settingBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.right.equalTo(settingBtn.snp.left).offset(-25)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        //tableView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
