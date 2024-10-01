//
//  ScholarshipNoticeViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import UIKit
import RxSwift

final class ScholarshipNoticeViewController: UIViewController, DataBindable, TableViewConfigurable, Scrollable {
    let viewModel: NoticeViewModel
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var disposeBag = DisposeBag()
    
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
        setupAttribute()
        setupNavigationBar(title: "장학안내")
        setupLayout()
        
        bindFetchingState()
        bindRefreshingState()
        setActivityIndicator()
        viewModel.fetchNotices()
    }
}

extension ScholarshipNoticeViewController: UITableViewDelegate {
    //MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WebViewController(url: viewModel.getNotices()[indexPath.row].contentUrl)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)    //선택 된 cell의 하이라이트 제거
    }
    
    //MARK: - TableView 스크롤 감지
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = scrollView.contentSize.height - scrollView.frame.size.height - 100
        
        if scrollView.contentOffset.y > threshold {
            guard !(viewModel.isFetching.value) && !viewModel.isFinished.value else { return }
            
            tableView.tableFooterView = createActivityIndicator()
            viewModel.fetchNextNotices()
        }
    }
}
