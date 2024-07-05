//
//  ScholarshipNoticeViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/5/24.
//

import UIKit
import RxSwift

final class ScholarshipNoticeViewController: UIViewController, CellDataBindable, TableViewConfigurable {
    var viewModel: NoticeViewModel
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var disposeBag = DisposeBag()
    
    init(viewModel: NoticeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        setupAttribute()
        setupNavigationBar(title: "장학안내")
        setupLayout()
        
        viewModel.fetchNotices()
    }
}

extension ScholarshipNoticeViewController: UITableViewDelegate {
    //MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WebViewController(url: viewModel.getNotices()[indexPath.row].contentURL)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)    //선택 된 cell의 하이라이트 제거
    }
}
