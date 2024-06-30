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

final class GeneralNoticeViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel = GeneralNoticeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "일반소식"
        setupLayout()
        setupAttribute()
    }
}

//MARK: - Binding
extension GeneralNoticeViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfNotice>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: MainListCell.reuseIdentifier)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "[\(item.department)]  \(item.uploadDate)"
            return cell
        })
        
        viewModel.getCellData()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

//MARK: - Helper
extension GeneralNoticeViewController {
    private func setupAttribute() {
        tableView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}

//MARK: - Preview
#Preview {
    GeneralNoticeViewController().makePreview()
}

