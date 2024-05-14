//
//  MainViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import SwiftUI
import RxDataSources

class MainViewController: UIViewController {
    private var viewModel: MainViewModel = MainViewModel()
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        setupAttribute()
        setupLayout()
    }
}

//MARK: - Binding
extension MainViewController {
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

//MARK: - UITableView delegate method
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerColors: [UIColor] = [.salmon, .lightOrange, .magentaPink, .magenta]
        let headerView = UIView()
        let button = UIButton(frame: CGRect(x: 15, y: -10, width: 90, height: 40))
        headerView.addSubview(button)
        button.setTitle(viewModel.notices.value[section].header, for: .normal)
        button.setTitleColor(headerColors[section], for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = headerColors[section]
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(headerButtonCallback(_:)), for: .touchUpInside)
        headerView.addSubview(button)
        
        return headerView
    }
}

//MARK: - Header Button Callback function
extension MainViewController {
    @objc
    func headerButtonCallback(_ sender: UIButton) {
        print("button tapped")
    }
}

//MARK: - Helper
extension MainViewController {
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
struct Preview: PreviewProvider {
    static var previews: some View {
        MainViewController().makePreview()
    }
}
