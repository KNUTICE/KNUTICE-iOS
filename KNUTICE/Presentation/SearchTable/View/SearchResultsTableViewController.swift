//
//  SearchResultsTableViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 4/18/25.
//

import UIKit
import SwiftUI
import Factory
import RxSwift

final class SearchResultsTableViewController: UIViewController {
    lazy var resultsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(DetailedNoticeCellWithImage.self, forCellReuseIdentifier: DetailedNoticeCellWithImage.reuseIdentifier)
        tableView.register(DetailedNoticeCell.self, forCellReuseIdentifier: DetailedNoticeCell.reuseIdentifier)
        
        return tableView
    }()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "공지사항 검색"
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = traitCollection.userInterfaceStyle == .light ? UIColor.white.cgColor : UIColor.black.cgColor
        
        return searchBar
    }()
    lazy var cancelButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let button = UIButton(configuration: configuration)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        
        return button
    }()
    @Injected(\.searchTableViewModel) var viewModel
    let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        searchBar.layer.borderColor = traitCollection.userInterfaceStyle == .light ? UIColor.white.cgColor : UIColor.black.cgColor
    }
    
    func resignFirstResponderIfNeeded() {
        searchBar.resignFirstResponder()
        updateSearchBarConstraints(isShowCancelButton: false)
    }
    
    @objc func cancelButtonAction(_ sender: UIButton) {
       resignFirstResponderIfNeeded()
    }
}

extension SearchResultsTableViewController: UITableViewDelegate {
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
        resignFirstResponderIfNeeded()
    }
}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponderIfNeeded()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchBarConstraints(isShowCancelButton: true)
    }
}

#Preview {
    SearchResultsTableViewController()
        .makePreview()
}
