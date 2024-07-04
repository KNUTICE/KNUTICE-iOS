//
//  CellDataBindable.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import UIKit
import RxSwift

protocol CellDataBindable {
    var viewModel: NoticeViewModel { get }
    var tableView: UITableView { get }
    var disposeBag: DisposeBag { get }
    
    func bind()
}

extension CellDataBindable {
    func bind() {
        viewModel.getCellData()
            .bind(to: tableView.rx.items) { tableView, row, item in
                if let imageURL = item.imageURL {
                    let cell = tableView.dequeueReusableCell(withIdentifier: GeneralNoticeCellWithImage.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! GeneralNoticeCellWithImage
                    cell.titleLabel.text = item.title
                    cell.subTitleLabel.text = "[\(item.department)]"
                    cell.uploadDateLabel.text = item.uploadDate
                    cell.imageURL = imageURL
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: GeneralNoticeCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! GeneralNoticeCell
                    cell.titleLabel.text = item.title
                    cell.subTitleLabel.text = "[\(item.department)]"
                    cell.uploadDateLabel.text = item.uploadDate
                    
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
}
