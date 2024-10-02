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
    let viewModel: MainViewModel
    let tableView = UITableView(frame: .zero, style: .grouped)
    let refreshControl = UIRefreshControl()
    let headerColors: [UIColor] = [.salmon, .lightOrange, .lightGreen, .dodgerBlue]
    let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        setupAttribute()
        setupNavigationBar()
        recordEntryTime()
        observeNotification()
        viewModel.fetchNotices()
    }
}

//MARK: - UITableView delegate method
extension MainViewController: UITableViewDelegate {
    //MARK: - Custom cell header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let title = UILabel()
        let arrowImage = UIImage(systemName: "chevron.right")
        let button = UIButton(type: .system)
        headerView.addSubview(title)
        headerView.addSubview(button)
        
        //Auto Layout
        title.snp.makeConstraints { make in
            make.leading.equalTo(headerView.safeAreaLayoutGuide).inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalTo(headerView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalToSuperview()
        }
        
        //Title Attribute
        title.text = viewModel.notices.value[section].header
        title.textColor = headerColors[section]
        title.font = UIFont.boldSystemFont(ofSize: 20)
        
        //Arrow Image Attribute
        let targetSize = CGSize(width: 8, height: 12)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { context in
            arrowImage?.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        //Button Attribute
        button.setTitle("더보기", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        button.tintColor = .grayButton
        button.setImage(resizedImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tag = section
        button.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
        
        return headerView
    }
    
    //MARK: - Section height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK: - Custom Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .footerGray
        return view
    }
    
    //MARK: - Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Remove separator from last cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }
    
    //MARK: - Cell이 선택 되었을 때 해당 공지사항 웹 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WebViewController(url: viewModel.getCellValue()[indexPath.section].items[indexPath.row].contentUrl)
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if DEBUG
//MARK: - Preview
struct Preview: PreviewProvider {
    static var previews: some View {
        let viewController = MainViewController(viewModel: AppDI.shared.makeMainViewModel())
        
        UINavigationController(rootViewController: viewController)
            .makePreview()
            .onAppear {
                viewController.bind()
            }
    }
}
#endif
