//
//  MainViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import SwiftUI
import RxDataSources

final class MainViewController: UIViewController {
    var viewModel: MainViewModel = AppDI.shared.mainViewModel
    var tableView = UITableView(frame: .zero, style: .grouped)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 15    //header padding
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(navigateToSetting(_:)))
        
        setupAttribute()
        setupLayout()
        
        viewModel.fetchNotices()
    }
}

//MARK: - UITableView delegate method
extension MainViewController: UITableViewDelegate {
    //MARK: - Custom cell header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerColors: [UIColor] = [.salmon, .lightOrange, .aquamarine,.midnightOcean]
        let headerView = UIView()
        let button = UIButton(frame: CGRect(x: 16, y: 5, width: 90, height: 40))
        headerView.addSubview(button)
        button.setTitle(viewModel.notices.value[section].header, for: .normal)
        button.setTitleColor(headerColors[section], for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = headerColors[section]
        button.semanticContentAttribute = .forceRightToLeft
        button.tag = section
        button.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(button)
        
        return headerView
    }
    
    //MARK: - Section height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK: - Custom Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .footerGray
        return view
    }
    
    //MARK: - Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Remove separator from last cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }
    
    //MARK: - Remove cell highlighting when touching a cell
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//MARK: - Preview
struct Preview: PreviewProvider {
    static var previews: some View {
        let viewController = MainViewController()
        UINavigationController(rootViewController: viewController)
            .makePreview()
            .onAppear {
                viewController.bind()
            }
    }
}
