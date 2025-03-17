//
//  MainViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import UIKit
import RxSwift
import SwiftUI
import Factory

final class MainViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 15    //header padding
        tableView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.reuseIdentifier)
        tableView.rowHeight = 95
        tableView.backgroundColor = .mainBackground
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    let navigationBar = UIView(frame: .zero)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "KNUTICE"
        label.font = UIFont.font(for: .title2, weight: .heavy)
        
        return label
    }()
    lazy var settingBtn: UIButton = {
        let targetSize = CGSize(width: 25, height: 24)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let gearImage = UIImage(systemName: "gearshape")
        let selectedGearImage = UIImage(systemName: "gearshape")?.withTintColor(.lightGray)
        let resizedGearImage = renderer.image { _ in
            gearImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }.withTintColor(.navigationButton)
        let resizedSelectedGearImage = renderer.image { _ in
            selectedGearImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(resizedGearImage, for: .normal)
        button.setImage(resizedSelectedGearImage, for: .highlighted)
        button.addTarget(self, action: #selector(navigateToSetting(_:)), for: .touchUpInside)
        
        return button
    }()
    lazy var searchBtn: UIButton = {
        let targetSize = CGSize(width: 25, height: 24)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let magnifyingglassImage = UIImage(systemName: "magnifyingglass")
        let selectedMagnifyingglassImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.lightGray)
        let resizedMagnifyingglassImage = renderer.image { _ in
            magnifyingglassImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }.withTintColor(.navigationButton)
        let resizedSelectedMagnifyingglassImage = renderer.image { _ in
            selectedMagnifyingglassImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(resizedMagnifyingglassImage, for: .normal)
        button.setImage(resizedSelectedMagnifyingglassImage, for: .highlighted)
        button.addTarget(self, action: #selector(navigateToSearch(_:)), for: .touchUpInside)
        
        return button
    }()
    let refreshControl = UIRefreshControl()
    @Injected(\.mainViewModel) var viewModel: MainViewModel
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .mainBackground
        setupLayout()
        bind()
        recordEntryTime()
        observeNotification()
        
        //API Call
        viewModel.fetchNoticesWithCombine()
    }
}

//MARK: - UITableView delegate method
extension MainViewController: UITableViewDelegate {
    //MARK: - Custom cell header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return makeSectionHeader(for: section)
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
        let viewController = WebViewController(notice: viewModel.getCellValue()[indexPath.section].items[indexPath.row].notice)
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if DEBUG
//MARK: - Preview
struct Preview: PreviewProvider {
    static var previews: some View {
        MainViewController()
            .makePreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
