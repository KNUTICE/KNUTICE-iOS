//
//  EventNoticeViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import UIKit
import RxSwift

final class EventNoticeViewController: UIViewController, DataBindable, TableViewConfigurable, Scrollable {
    let viewModel: NoticeViewModel
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let disposeBag = DisposeBag()
    
    init(viewModel: NoticeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        setupAttribute(showRefreshControl: true)
        setupNavigationBar(title: "행사안내")
        setupLayout()
        
        bindFetchingState()
        bindRefreshingState()
        bindWillDisplayCell()
        setActivityIndicator()
        viewModel.fetchNotices()
    }
}

extension EventNoticeViewController: UITableViewDelegate {
    //MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WebViewController(notice: viewModel.getNotices()[indexPath.row],
                                               isBookmarkBtnVisible: true)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)    //선택 된 cell의 하이라이트 제거
    }
}
