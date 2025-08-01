//
//  MainTableViewController+Callbacks.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import UIKit
import SwiftUI
import Factory

//MARK: - Callback Function
extension MainTableViewController {
    @objc func headerButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        switch section {
        case 0:
            navigateToGeneralNotice(sender)
        case 1:
            navigateToAcademicNotice(sender)
        case 2:
            navigateToScholarshipNotice(sender)
        case 3:
            navigateToEventNotice(sender)
        case 4:
            navigateToEmploymentNotice()
        default:
            break
        }
    }
    
    //MARK: - General Notice Button Callback Function
    func navigateToGeneralNotice(_ sender: UIButton) {
        let viewController = NoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: .generalNotice), navigationTitle: "일반소식")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Academic Notice Button Callback Function
    func navigateToAcademicNotice(_ sender: UIButton) {
        let viewController = NoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: .academicNotice), navigationTitle: "학사공지")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Scholarship Notice Button Callback Function
    func navigateToScholarshipNotice(_ sender: UIButton) {
        let viewController = NoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: .scholarshipNotice), navigationTitle: "장학안내")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Event Notice Button Callback Function
    func navigateToEventNotice(_ sender: UIButton) {
        let viewController = NoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: .eventNotice), navigationTitle: "장학안내")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Employment Notice Button Callback Function
    func navigateToEmploymentNotice() {
        let viewController = NoticeCollectionViewController(
            viewModel: NoticeCollectionViewModel(category: .employmentNotice),
            navigationTitle: "취업안내"
        )
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Setting Button Action
    @objc func navigateToSetting(_ sender: UIButton) {
        let viewController = UIHostingController(rootView: SettingView())
        navigationController?.pushViewController(viewController, animated: true)
    }
}
