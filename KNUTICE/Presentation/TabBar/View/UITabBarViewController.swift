//
//  UITabBarViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import UIKit
import SwiftUI
import RxSwift

final class UITabBarViewController: UITabBarController {
    private let mainViewController = MainTableViewController()
    private let reminderViewController = UIHostingController(
        rootView: BookmarkList(viewModel: BookmarkListViewModel())
    )
    let viewModel: TabBarViewModel
    let disposeBag: DisposeBag = .init()
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([mainViewController, reminderViewController], animated: true)
        setupShadowView()
        setupTabBar()
        bind()
        openPushNoticeIfExists()
        
        if UserDefaults.standard.double(forKey: "noShowPopupDate") < Date().timeIntervalSince1970 {
            viewModel.fetchMainPopupContent()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension UITabBarViewController {
    private func setupTabBar() {
        mainViewController.tabBarItem.image = UIImage(systemName: "house")
        mainViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        mainViewController.tabBarItem.title = "홈"
        
        reminderViewController.tabBarItem.image = UIImage(systemName: "bookmark")
        reminderViewController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        reminderViewController.tabBarItem.title = "북마크"
        
        tabBar.backgroundColor = .tabBar
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .tabBar
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupShadowView() {
        let shadowView = UIView(frame: .zero)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .tabBar
        shadowView.layer.cornerRadius = 20
        shadowView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.borderWidth = 1
        shadowView.layer.borderColor = UIColor.tabBar.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 25)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 20
        
        view.addSubview(shadowView)
        view.bringSubviewToFront(tabBar)
        shadowView.snp.makeConstraints { make in
            make.width.equalTo(tabBar.snp.width)
            make.height.equalTo(tabBar.snp.height).offset(-1)
            make.centerX.equalTo(tabBar.snp.centerX)
            make.bottom.equalTo(tabBar.snp.bottom)
        }
    }
}

extension UITabBarViewController {
    func openPushNoticeIfExists() {
        let decoder = JSONDecoder()
        if let encodedData = UserDefaults.standard.data(forKey: "pushNotice"),
           let notice = try? decoder.decode(Notice.self, from: encodedData) {
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.pushViewController(WebViewController(notice: notice), animated: true)
                UserDefaults.standard.set(nil, forKey: "pushNotice")
            }
        }
    }
}

extension UITabBarViewController {
    func bind() {
        viewModel
            .mainPopupContent
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] in
                if let element = $0.element, let popupContent = element, let self = self {
                    let bottomModal = BottomModal(content: popupContent)
                    self.view.addSubview(bottomModal)
                    bottomModal.setupLayout()
                    UIView.animate(withDuration: 0.5) {
                        bottomModal.alpha = 1
                    }
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.openPushNoticeIfExists()
            })
            .disposed(by: disposeBag)
    }
}


#if DEBUG
struct UITabBarViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: UITabBarViewController(viewModel: TabBarViewModel()))
            .makePreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
