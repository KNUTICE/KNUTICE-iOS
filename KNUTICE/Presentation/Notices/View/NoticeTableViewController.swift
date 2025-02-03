//
//  NoticeTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import UIKit
import SwiftUI
import RxSwift

final class NoticeTableViewController: UIViewController, TableViewConfigurable, DataBindable, Scrollable {
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let viewModel: NoticeViewModel
    let disposeBag = DisposeBag()
    private let navigationTitle: String
    
    init(viewModel: NoticeViewModel, navigationTitle: String) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        bind()
        setupLayout()
        setupAttribute(showRefreshControl: true)
        setupNavigationBar(title: navigationTitle)
        
        bindFetchingState()
        bindRefreshingState()
        bindWillDisplayCell()
        setActivityIndicator()
        
        //API Call
        viewModel.fetchNotices()
    }
}

//MARK: - UIViewController delegate methods
extension NoticeTableViewController: UITableViewDelegate {
    //MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WebViewController(notice: viewModel.getNotices()[indexPath.row],
                                               isBookmarkBtnVisible: true)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)    //선택 된 cell의 하이라이트 제거
    }
}

//MARK: - Preview
#if DEBUG
#Preview {
    NoticeTableViewController(viewModel: AppDI.shared.makeGeneralNoticeViewModel(), navigationTitle: "일반공지")
        .makePreview()
}
#endif
