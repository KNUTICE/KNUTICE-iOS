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

final class GeneralNoticeViewController: UIViewController, TableViewConfigurable, CellDataBindable {
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    let viewModel: NoticeViewModel = AppDI.shared.generalNoticeViewModel
    let disposeBag = DisposeBag()
    private let navigationTitle: String = "일반소식"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        setupLayout()
        setupAttribute()
        setupNavigationBar(title: navigationTitle)
        
        viewModel.fetchNotices()
    }
}

//MARK: - UIViewController delegate methods
extension GeneralNoticeViewController: UITableViewDelegate {
    //MARK: - Remove separator from last cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }
    
    //MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WebViewController(url: viewModel.getNotices()[indexPath.row].contentURL)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)    //선택 된 cell의 하이라이트 제거
    }
}

//MARK: - Preview
#Preview {
    GeneralNoticeViewController()
        .makePreview()
}

