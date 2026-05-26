//
//  BookmarkTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import ComposableArchitecture
import Combine
import CorePresentation
import Factory
import KNDesignSystem
import KNDomain
import KNUtility
import UIKit
import SwiftUI
import RxSwift

public final class BookmarkTableViewController: UIViewController {
    let refreshController: UIRefreshControl = UIRefreshControl()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100    //cell height가 설정되기 전 임시 크기
        tableView.rowHeight = UITableView.automaticDimension    //동적 Height 설정
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.refreshControl = refreshController
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BookmarkListRow.reuseIdentifier)
        
        return tableView
    }()
    let viewModel: BookmarkTableViewModel
    public var sortedBookmarkViewModel: BookmarkSortOptionProvidable { viewModel }
    let disposeBag: DisposeBag = .init()
    var cancellables: Set<AnyCancellable> = []
    
    public init(viewModel: BookmarkTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        setUpLayout()
        bind()
        viewModel.observePublisher()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.fetchTask?.cancel()
        viewModel.deleteTask?.cancel()
        viewModel.reloadTask?.cancel()
    }
    
}

extension BookmarkTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = viewModel.bookmarks.value[indexPath.section].items[0]
        let store = Store(
            initialState: BookmarkContainerFeature.State.detail(BookmarkDetailFeature.State(bookmark: bookmark, nttId: bookmark.identity)),
            reducer: { BookmarkContainerFeature() }
        )

        let rootView = BookmarkContainerView(
            store: store,
            dismissAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        let viewController = UIHostingController(rootView: rootView)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if DEBUG
struct MockFetchBookmarksUseCase: FetchBookmarksUseCase {
    func execute(page: Int, pageSize: Int, sortBy option: BookmarkSortOption) async throws -> [Bookmark] {
        return []
    }
    
    func execute(for id: Int) async throws -> Bookmark? {
        return nil
    }
}

struct MockProviderReloadEventPublisher: ProvideReloadEventPublisherUseCase {
    var eventPublisher: AnyPublisher<ReloadEvent, Never> {
        Empty().eraseToAnyPublisher()
    }
}

struct MockDeleteBookmarkUseCase: DeleteBookmarkUseCase {
    func execute(for bookmark: Bookmark) async throws {}
}

#Preview {
    BookmarkTableViewController(
        viewModel: BookmarkTableViewModel(
            fetchBookmarksUseCase: MockFetchBookmarksUseCase(),
            providerReloadEventPublisherUseCase: MockProviderReloadEventPublisher(),
            deleteBookmarkUseCase: MockDeleteBookmarkUseCase()
        )
    )
    .makePreview()
    .edgesIgnoringSafeArea(.all)
}
#endif
