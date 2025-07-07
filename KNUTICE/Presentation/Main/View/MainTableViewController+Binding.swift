//
//  MainTableViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift
import RxDataSources
import UIKit

//MARK: - Binding
extension MainTableViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfNotice>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            if item.presentationType == .actual {
                let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as! MainTableViewCell
                cell.configure(with: item)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewSkeletonCell.reuseIdentifier, for: indexPath) as! MainTableViewSkeletonCell
                cell.configure(with: item)
                
                return cell
            }
        })
        
        viewModel.noticesObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //ViewModel의 isLoading의 값이 변경 되었을 때 refreshControl의 isRegreshing의 값 변경되도록 바인딩
        viewModel.isLoadingObservable
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        //RefreshControl의 valueChanged 이벤트 관찰 후 수행할 작업
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.viewModel.refreshNoticesWithCombine()
            }
            .disposed(by: disposeBag)
        
        // Tip API에서 새 팁 데이터가 도착했음을 알리는 Notification(.hasTipData)을 수신하면
        // 1) tableHeaderView 높이를 70pt로 확정하고 화면 너비에 맞춰 리사이즈한 뒤
        // 2) beginUpdates / endUpdates 로 테이블 레이아웃을 즉시 갱신
        NotificationCenter.default.rx.notification(Notification.Name.hasTipData)
            .bind(with: self) { owner, _ in
                owner.tableView.tableHeaderView?.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: owner.view.bounds.width,
                    height: 70
                )
                owner.tableView.beginUpdates()
                owner.tableView.endUpdates()
            }
            .disposed(by: disposeBag)
    }
}
