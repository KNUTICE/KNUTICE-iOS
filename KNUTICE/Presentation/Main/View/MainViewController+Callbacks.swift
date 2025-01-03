//
//  MainViewController+Callbacks.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import UIKit
import SwiftUI

//MARK: - Callback Function
extension MainViewController {
    @objc
    func headerButtonTapped(_ sender: UIButton) {
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
        default:
            break
        }
    }
    
    //MARK: - General Notice Button Callback Function
    func navigateToGeneralNotice(_ sender: UIButton) {
        let viewController = GeneralNoticeViewController(viewModel: AppDI.shared.makeGeneralNoticeViewModel())
        viewController.bind()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Academic Notice Button Callback Function
    func navigateToAcademicNotice(_ sender: UIButton) {
        let viewController = AcademicNoticeViewController(viewModel: AppDI.shared.makeAcademicNoticeViewModel())
        viewController.bind()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Scholarship Notice Button Callback Function
    func navigateToScholarshipNotice(_ sender: UIButton) {
        let viewController = ScholarshipNoticeViewController(viewModel: AppDI.shared.makeScholarshipNoticeViewModel())
        viewController.bind()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Event Notice Button Callback Function
    func navigateToEventNotice(_ sender: UIButton) {
        let viewController = EventNoticeViewController(viewModel: AppDI.shared.makeEventNoticeViewModel())
        viewController.bind()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Toolbar Button Callback Function
    @objc func navigateToSetting(_ sender: UIButton) {
        let viewController = UIHostingController(rootView: SettingView(viewModel: AppDI.shared.makeSettingViewModel()))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func navigateToSearch(_ sender: UIButton) {
        let viewController = SearchTableViewController(viewModel: AppDI.shared.makeSearchTableViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
