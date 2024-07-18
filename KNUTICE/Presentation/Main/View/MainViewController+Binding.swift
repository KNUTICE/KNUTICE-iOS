//
//  MainViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift
import RxDataSources

//MARK: - Binding
extension MainViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfNotice>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in            
            let cell = tableView.dequeueReusableCell(withIdentifier: MainListCell.reuseIdentifier, for: indexPath) as! MainListCell
            cell.selectionStyle = .none
            
            if item.presentationType == .skeleton {
                cell.configureSkeleton(with: item)
            } else {
                cell.configure(with: item)
            }
            
            return cell
        })
        
        viewModel.getCellData()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
