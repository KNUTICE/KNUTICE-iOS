//
//  GeneralNoticeViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import UIKit
import SwiftUI
import RxCocoa
import RxSwift
import RxDataSources

final class GeneralNoticeViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    let viewModel = AppDI.shared.generalNoticeViewModel
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        setupAttribute()
        setupNavigationBar()
    }
}

//MARK: - UIViewController delegate methods
extension GeneralNoticeViewController: UITableViewDelegate {
    //MARK: - Height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
#Preview {
    GeneralNoticeViewController()
        .makePreview()
}

