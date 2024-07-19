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

final class GeneralNoticeViewController: UIViewController, TableViewConfigurable, DataBindable, Scrollable {    
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
        
        bindFetchingState()
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
            guard !(viewModel.isFetching.value) else { return }
            
            tableView.tableFooterView = createActivityIndicator()
            viewModel.fetchNextNotices()
        }
    }
    
    func setActivityIndicator() {
        let spinner = UIActivityIndicatorView(style: .large)
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
}

//MARK: - Preview
#if DEBUG
#Preview {
    GeneralNoticeViewController()
        .makePreview()
}
#endif
