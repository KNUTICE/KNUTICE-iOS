//
//  BookmarkTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

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
    let navigationBar = UIView(frame: .zero)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "북마크"
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        
        return label
    }()
    lazy var settingBtn: UIButton = {
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let gearImage = UIImage(systemName: "gearshape", withConfiguration: configuration)?
            .withRenderingMode(.alwaysTemplate)
        let selectedGearImage = UIImage(systemName: "gearshape", withConfiguration: configuration)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.lightGray)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(gearImage, for: .normal)
        button.setImage(selectedGearImage, for: .highlighted)
        button.addTarget(self, action: #selector(navigateToSetting(_:)), for: .touchUpInside)
        
        return button
    }()
    let menuBtn: UIButton = {
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let upAndDownImage = UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: configuration)?
            .withRenderingMode(.alwaysTemplate)
        let selectedUpAndDownImage = UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: configuration)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.lightGray)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.setImage(upAndDownImage, for: .normal)
        button.setImage(selectedUpAndDownImage, for: .highlighted)
        
        return button
    }()
    @Injected(\.bookmarkTableViewModel) var viewModel
    let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBackground
        setUpLayout()
        bind()
        
        viewModel.fetchBookmarks()
    }
}

extension BookmarkTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = viewModel.bookmarks.value[indexPath.section].items[0]
        let viewController = UIHostingController(
            rootView: BookmarkDetailSwitchView(viewModel: BookmarkFormViewModel(bookmark: bookmark))
        )
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BookmarkTableViewController {
    @objc func navigateToSetting(_ sender: UIButton) {
        let viewController = UIHostingController(rootView: SettingView())
        navigationController?.pushViewController(viewController, animated: true)
    }
}

#if DEBUG
#Preview {
    BookmarkTableViewController()
        .makePreview()
        .edgesIgnoringSafeArea(.all)
}
#endif
