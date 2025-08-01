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

final class MainTableViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    let navigationBar = UIView(frame: .zero)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "KNUTICE"
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
        createNavigationItems()
        bind()
        recordEntryTime()
        subscribeEntryTime()
        
        //API Call
        viewModel.fetchNoticesWithCombine()
    }
    
    func createNormalBellIcon() -> UIImage? {
        let configuration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        
        if UserDefaults.shared.bool(forKey: UserDefaultsKeys.hasNewPendingNotice.rawValue) {
            let paletteStyleConfig = UIImage.SymbolConfiguration(paletteColors: [.red, .black])
            configuration.applying(paletteStyleConfig)
            return UIImage(systemName: "bell.badge", withConfiguration: configuration)?
                .withRenderingMode(.alwaysOriginal)
        }
        
        return UIImage(systemName: "bell", withConfiguration: configuration)?
            .withRenderingMode(.alwaysTemplate)
    }
    
    func createHighlightedBellIcon() -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        
        if UserDefaults.shared.bool(forKey: UserDefaultsKeys.hasNewPendingNotice.rawValue) {
            return UIImage(systemName: "bell.badge", withConfiguration: configuration)?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.lightGray)
        }
        
        return UIImage(systemName: "bell", withConfiguration: configuration)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.lightGray)
    }
}

//MARK: - UITableView delegate method
extension MainTableViewController: UITableViewDelegate {
    //MARK: - Custom cell header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createSectionHeader(for: section)
    }
    
    //MARK: - Section height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - Remove separator from last cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }
    
    //MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WebViewController(notice: viewModel.cellValues[indexPath.section].items[indexPath.row].notice)
        navigationController?.pushViewController(viewController, animated: true)
        
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
