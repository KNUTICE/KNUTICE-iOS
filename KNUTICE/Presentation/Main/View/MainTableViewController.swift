//
//  MainTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import Combine
import UIKit
import RxSwift
import SwiftUI
import Factory

final class MainTableViewController: UIViewController, FirstTabNavigationItemConfigurable, SettingButtonConfigurable {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 15    //header padding
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        tableView.register(MainTableViewSkeletonCell.self, forCellReuseIdentifier: MainTableViewSkeletonCell.reuseIdentifier)
        tableView.estimatedRowHeight = 100    //cell height가 설정되기 전 임시 크기
        tableView.rowHeight = UITableView.automaticDimension    //동적 Height 설정
        tableView.backgroundColor = .primaryBackground
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    let tipView = UIHostingController(rootView: TipBannerView().environmentObject(TipBannerViewModel())).view
    let refreshControl = UIRefreshControl()
    @Injected(\.mainViewModel) var viewModel: MainTableViewModel
    let disposeBag = DisposeBag()
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .primaryBackground
        setupLayout()
        bind()
        recordEntryTime()
        subscribeEntryTime()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            setTitleBarButtonItem()
            setSettingBarButtonItem()
        }
        
        //API Call
        viewModel.fetchNotices()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.task?.cancel()
    }

}

// MARK: - UITableView delegate method
extension MainTableViewController: UITableViewDelegate {
    // MARK: - Custom cell header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createSectionHeader(for: section)
    }
    
    // MARK: - Section height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Remove separator from last cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }
    
    // MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notice = viewModel.cellValues[indexPath.section].items[indexPath.row].notice
        let viewController = NoticeContentViewController(
            viewModel: NoticeContentViewModel(notice: notice)
        )
        
        // 화면 이동
        navigationController?.pushViewController(viewController, animated: true)
        
        // 선택된 Cell 초기화
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if DEBUG
//MARK: - Preview
struct Preview: PreviewProvider {
    static var previews: some View {
        MainTableViewController()
            .makePreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif

