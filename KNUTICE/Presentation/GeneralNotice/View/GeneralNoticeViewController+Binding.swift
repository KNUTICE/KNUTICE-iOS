//
//  GeneralViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/2/24.
//

import RxCocoa

//MARK: - Binding
extension GeneralNoticeViewController {
    func bind() {
        viewModel.getCellData()
            .bind(to: tableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralNoticeCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! GeneralNoticeCell
                cell.titleLabel.text = item.title
                cell.subTitleLabel.text = "[\(item.department)]"
                cell.uploadDateLabel.text = item.uploadDate
                
                return cell
            }
            .disposed(by: disposeBag)
    }
}
