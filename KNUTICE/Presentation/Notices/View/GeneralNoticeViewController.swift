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

final class GeneralNoticeViewController: UIViewController, TableViewConfigurable, DataBindable, Scrollable {    
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let viewModel: NoticeViewModel
    let disposeBag = DisposeBag()
    private let navigationTitle: String = "일반소식"
    
    init(viewModel: NoticeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        setupLayout()
        setupAttribute(showRefreshControl: true)
        setupNavigationBar(title: navigationTitle)
        
        bindFetchingState()
        bindRefreshingState()
        setActivityIndicator()
        viewModel.fetchNotices()
    }
}

//MARK: - UIViewController delegate methods
extension GeneralNoticeViewController: UITableViewDelegate {
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

//MARK: - Preview
#if DEBUG
#Preview {
    GeneralNoticeViewController(viewModel: AppDI.shared.makeGeneralNoticeViewModel())
        .makePreview()
}
#endif
