//
//  BookmarkTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import Combine
import Factory
import UIKit
import SwiftUI
import RxSwift

final class BookmarkTableViewController: UIViewController {
    let refreshController: UIRefreshControl = UIRefreshControl()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100    //cell height가 설정되기 전 임시 크기
        tableView.rowHeight = UITableView.automaticDimension    //동적 Height 설정
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.refreshControl = refreshController
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    @Injected(\.bookmarkTableViewModel) var viewModel: BookmarkTableViewModel
    var sortedBookmarkViewModel: BookmarkSortOptionProvidable {
        return viewModel
    }
    let disposeBag: DisposeBag = .init()
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackground
        setUpLayout()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.fetchTask?.cancel()
        viewModel.deleteTask?.cancel()
        viewModel.reloadTask?.cancel()
    }
    
    @objc func navigateToSetting(_ sender: UIButton) {
        let viewController = UIHostingController(rootView: SettingView())
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension BookmarkTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = viewModel.bookmarks.value[indexPath.section].items[0]
        let viewController = UIHostingController(
            rootView: BookmarkDetailSwitchView(viewModel: BookmarkViewModel(bookmark: bookmark))
        )
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if DEBUG
#Preview {
    BookmarkTableViewController()
        .makePreview()
        .edgesIgnoringSafeArea(.all)
}
#endif
