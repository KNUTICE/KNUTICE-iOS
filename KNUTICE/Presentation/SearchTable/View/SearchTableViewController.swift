//
//  SearchTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/7/24.
//

import UIKit
import SwiftUI
import RxSwift

final class SearchTableViewController: UIViewController, TableViewConfigurable {
    let tableView = UITableView(frame: .zero, style: .grouped)
    let searchBar = UISearchBar()
    let refreshControl = UIRefreshControl()    //protocol 요구사항 구현
    let viewModel: SearchResultRepresentable
    let disposeBag = DisposeBag()
    
    init(viewModel: SearchTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        setupLayout()
        setUpBackgroundView()
        setupAttribute(showRefreshControl: false)
        setUpNavigationBar()
        bindWithSearchBar()
        bindWithTableView()
        bindWithBackgroundView()
        tableView.contentInset = UIEdgeInsets(top: -34, left: 0, bottom: 0, right: 0);    //상단 빈 공간 제거
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()    //키보드 자동 활성화
    }
}

extension SearchTableViewController: UITableViewDelegate {
    //MARK: - Cell 선택 시 해당 공지사항으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let notice = viewModel.getNotices()?[indexPath.row] else {
            return
        }
        
        let viewController = WebViewController(notice: notice)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - 스크롤 감지 후 키보드 숨김
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //드래그 시작 후 한번만 호출
        searchBar.resignFirstResponder()
    }
}

#if DEBUG
struct SearchTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: SearchTableViewController(viewModel: SearchTableViewModel()))
            .makePreview()
    }
}
#endif
