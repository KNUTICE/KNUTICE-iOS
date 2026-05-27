//
//  UITabBarViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import Combine
import ComposableArchitecture
import CorePresentation
import Factory
import KNBookmark
import KNDomain
import KNNotice
import KNSearch
import KNSetting
import KNUtility
import UIKit
import SwiftUI

typealias NavigationItemConfigurable = FirstTabNavigationItemConfigurable & SecondTabNavigationItemConfigurable & SettingButtonConfigurable & ThirdTabNavigationItemConfigurable

final class UITabBarViewController: UITabBarController, NavigationItemConfigurable {
    
    let viewModel: TabBarViewModel
    var cancellables: Set<AnyCancellable> = []
    
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var sortedBookmarkViewModel: BookmarkSortOptionProvidable {
        viewModel
    }
    
    private lazy var mainViewController: UIViewController = {
        let store = Store(initialState: HomeScreenFeature.State()) {
            HomeScreenFeature()
        }
        let viewController = UIHostingController(rootView: HomeScreenView(store: store))
        viewController.tabBarItem.image = UIImage(systemName: "house")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        viewController.tabBarItem.title = "홈"
        
        if isPad {
            return UINavigationController(rootViewController: viewController)
        }
        
        return viewController
    }()
    
    private lazy var majorNoticeViewController: UIViewController = {
        let viewController = NoticeTabViewController(noticeCollectionViewControllerFactory: NoticeCollectionViewControllerFactoryImpl())
        viewController.tabBarItem.image = UIImage(systemName: "megaphone")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "megaphone.fill")
        viewController.tabBarItem.title = "공지"
        
        if isPad {
            return UINavigationController(rootViewController: viewController)
        }
        
        return viewController
    }()
    
    private lazy var bookmarkViewController: UIViewController = {
        let viewController = BookmarkTableViewController(viewModel: Container.shared.bookmarkTableViewModel())
        viewController.tabBarItem.image = UIImage(systemName: "bookmark")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        viewController.tabBarItem.title = "북마크"
        
        if isPad {
            return UINavigationController(rootViewController: viewController)
        }
        
        return viewController
    }()
    
    private lazy var searchViewController: UIViewController = {
        let viewController = SearchViewController() { [weak self] notice in
            self?.bookmarkFormFactory.make(for: notice)
        }
        
        if #available(iOS 26, *) {
            viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
            
            return viewController
        } else {
            viewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
            
            if UIDevice.current.userInterfaceIdiom  == .phone {
                viewController.tabBarItem.title = "검색"
            }
            
            if isPad {
                return UINavigationController(rootViewController: viewController)
            }
            
            return viewController
        }
    }()
    
    private let bookmarkFormFactory: BookmarkFormFactory = BookmarkFormFactoryImpl()
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setUpTabBar()
        bind()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            setFirstTabNavigationItems()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isPad {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            let isSearchTab = viewControllers?[selectedIndex] is SearchViewController
            navigationController?.setNavigationBarHidden(isSearchTab, animated: false)
        }
    }
}

extension UITabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch viewController {
            case is UIHostingController<HomeScreenView>:
                setFirstTabNavigationItems()
            case is NoticeTabViewController:
                setSecondTabNavigationItems()
            case is BookmarkTableViewController:
                setThirdTabNavigationItems(selectedOption: viewModel.bookmarkSortOption)
            default:
                removeAllNavigationItems()
            }
        }
    }
}

extension UITabBarViewController {
    func setFirstTabNavigationItems() {
        // Bookmark의 rightBarButtonItems 제거
        navigationItem.rightBarButtonItems = nil
        setTitleBarButtonItem()
        setSettingBarButtonItem()
    }
    
    func setSecondTabNavigationItems() {
        // Bookmark의 rightBarButtonItems 제거
        navigationItem.rightBarButtonItems = nil
        setNoticeBarButtonItem()
        setSettingBarButtonItem()
    }
    
    func setThirdTabNavigationItems(selectedOption sortOption: BookmarkSortOption) {
        makeBookmarkTitleBarItem()
        navigationItem.rightBarButtonItems = [
            settingBarButtonItem,
            makeSortMenuButton(selectedOption: sortOption)
        ]
    }
    
    func removeAllNavigationItems() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItems = nil
    }
}

extension UITabBarViewController {
    func setUpTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        if #available(iOS 18, *), isPad {
            tabs = [
                UITab(title: "홈", image: UIImage(systemName: "house.fill"), identifier: "Tabs.main") { _ in
                    self.mainViewController
                },
                UITab(title: "공지", image: UIImage(systemName: "globe.fill"), identifier: "Tabs.majorNotice") { _ in
                    self.majorNoticeViewController
                },
                UITab(title: "북마크", image: UIImage(systemName: "bookmark.fill"), identifier: "Tabs.bookmark") { _ in
                    self.bookmarkViewController
                },
                UISearchTab { _ in
                    self.searchViewController
                }
            ]
        } else {
            setViewControllers([mainViewController, majorNoticeViewController, bookmarkViewController, searchViewController], animated: true)
        }
    }
}


#if DEBUG
struct UITabBarViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: UITabBarViewController(
            viewModel: TabBarViewModel(category: .computerScience))
        )
        .makePreview()
        .edgesIgnoringSafeArea(.all)
    }
}
#endif

