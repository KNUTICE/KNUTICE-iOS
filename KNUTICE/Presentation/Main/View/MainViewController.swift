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

final class MainViewController: UIViewController {
    private var viewModel: MainViewModel = MainViewModel()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(navigateToSetting(_:)))
        setupAttribute()
        setupLayout()
    }
}

//MARK: - Binding
extension MainViewController {
    func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfNotice>(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: MainListCell.reuseIdentifier, for: indexPath) as! MainListCell
            cell.titleLabel.text = item.title
            cell.subTitleLabel.text = "[\(item.department)]"
            cell.uploadDateLabel.text = item.uploadDate
            
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
    //MARK: - Custom cell header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerColors: [UIColor] = [.salmon, .lightOrange, .aquamarine,.midnightOcean]
        let headerView = UIView()
        let button = UIButton(frame: CGRect(x: 15, y: 12, width: 90, height: 40))
        headerView.addSubview(button)
        button.setTitle(viewModel.notices.value[section].header, for: .normal)
        button.setTitleColor(headerColors[section], for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = headerColors[section]
        button.semanticContentAttribute = .forceRightToLeft
        button.tag = section
        button.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(button)
        headerView.backgroundColor = .white
        
        return headerView
    }
    
    //MARK: - Section height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    //MARK: - Custom Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .footerGray
        return view
   }
    
    //MARK: - Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    //MARK: - Remove separator from last cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }
}

//MARK: - Callback Function
extension MainViewController {
    @objc func headerButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        switch section {
        case 0:
            navigateToGeneralNotice(sender)
        case 1:
            navigateToAcademicNotice(sender)
        case 2:
            navigateToScholarshipNotice(sender)
        case 3:
            navigateToEventNotice(sender)
        default:
            break
        }
    }
    
    //MARK: - General Notice Button Callback Function
    func navigateToGeneralNotice(_ sender: UIButton) {
        let viewController = GeneralNoticeViewController()
        viewController.bind()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Academic Notice Button Callback Function
    func navigateToAcademicNotice(_ sender: UIButton) {
        
    }
    
    //MARK: - Scholarship Notice Button Callback Function
    func navigateToScholarshipNotice(_ sender: UIButton) {
        
    }
    
    //MARK: - Event Notice Button Callback Function
    func navigateToEventNotice(_ sender: UIButton) {
        
    }
    
    //MARK: - Toolbar Button Callback Function
    @objc
    func navigateToSetting(_ sender: UIButton) {
        let viewController = SettingViewController()
        navigationController?.pushViewController(viewController, animated: true)
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
        //TableView Constraint
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        let bannerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bannerView.backgroundColor = .lightGray
        bannerView.layer.cornerRadius = 10
        
        let bannerContainerView = UIView()
        bannerContainerView.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        bannerContainerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        tableView.tableHeaderView = bannerContainerView
        
        let label = UILabel()
        label.text = "광고 자리"
        label.font = UIFont.systemFont(ofSize: 20)
        label.tintColor = .black
        bannerView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
}

//MARK: - Preview
struct Preview: PreviewProvider {
    static var previews: some View {
        let viewController = MainViewController()
        UINavigationController(rootViewController: viewController).makePreview()
            .onAppear {
                viewController.bind()
            }
    }
}
