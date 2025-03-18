//
//  MainTableViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift
import RxDataSources

//MARK: - Binding
extension MainTableViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfNotice>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in            
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as! MainTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
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
        
        //ViewModel의 isLoading의 값이 변경 되었을 때 refreshControl의 isRegreshing의 값 변경되도록 바인딩
        viewModel.isLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        //RefreshControl의 valueChanged 이벤트 관찰 후 수행할 작업
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.viewModel.refreshNoticesWithCombine()
            })
            .disposed(by: disposeBag)
    }
}
