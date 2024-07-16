//
//  DataBindable.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import RxSwift

protocol DataBindable {
    var viewModel: NoticeViewModel { get }
    var tableView: UITableView { get }
    var disposeBag: DisposeBag { get }
    
    func bind()
}

extension DataBindable {
    func bind() {
        viewModel.noticesObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tableView, row, item in
                if let imageURL = item.imageUrl {
                    let cell = tableView.dequeueReusableCell(withIdentifier: DetailedNoticeCellWithImage.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! DetailedNoticeCellWithImage
                    cell.titleLabel.text = item.title
                    cell.subTitleLabel.text = "[\(item.department)]"
                    cell.uploadDateLabel.text = item.uploadDate
                    cell.imageURL = imageURL
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: DetailedNoticeCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! DetailedNoticeCell
                    cell.titleLabel.text = item.title
                    cell.subTitleLabel.text = "[\(item.department)]"
                    cell.uploadDateLabel.text = item.uploadDate
                    
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
}
