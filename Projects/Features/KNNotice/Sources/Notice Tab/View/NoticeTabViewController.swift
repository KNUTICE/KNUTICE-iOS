//
//  NoticeTabViewController.swift
//  KNNotice
//
//  Created by 이정훈 on 4/10/26.
//

import KNDeepLink
import KNDesignSystem
import KNDomain
import KNSetting
import KNUtility
import UIKit
import RxRelay
import RxSwift
import SnapKit
import SwiftUI

public final class NoticeTabViewController: UIViewController, SettingButtonConfigurable {
    /// Horizontal scroll collection view displaying category tabs and an add button.
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(AddButtonCell.self, forCellWithReuseIdentifier: AddButtonCell.reuseIdentifier)
        
        return collectionView
    }()
    
    /// Page view controller that displays notice content for each category.
    private lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        viewController.delegate = self
        viewController.dataSource = self
        
        return viewController
    }()
    
    private let noticeCollectionViewControllerFactory: NoticeCollectionViewControllerFactory
    
    /// List of view controllers corresponding to each category tab.
    private var viewControllers: [UIViewController] = []
    
    /// View model managing category data and selected tab index.
    private let viewModel: NoticeTabViewModel = NoticeTabViewModel()
    
    /// Dispose bag for managing RxSwift subscriptions.
    private let disposeBag: DisposeBag = .init()
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private let noticeTabSettingsFactory: NoticeTabSettingsFactory
    
    public init(
        noticeCollectionViewControllerFactory: NoticeCollectionViewControllerFactory,
        noticeTabSettingsFactory: NoticeTabSettingsFactory
    ) {
        self.noticeCollectionViewControllerFactory = noticeCollectionViewControllerFactory
        self.noticeTabSettingsFactory = noticeTabSettingsFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        setupCollectionViewLayout()
        setupPageViewLayout()
        bindCollectionView()
        bindCollectionViewSelection()
        bindSelectedIndex()
        
        if isPad {
            setLeftBarButtonItem()
            setSettingBarButtonItem()
        }
    }
    
    /// Adds the category collection view to the view hierarchy and applies constraints.
    private func setupCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    /// Embeds the page view controller as a child and applies constraints below the collection view.
    private func setupPageViewLayout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /// Binds the category data stream to the collection view and initializes the page view controller
    /// with the first category on load.
    private func bindCollectionView() {
        viewModel.categories
            .observe(on: MainScheduler.instance)
            .do { [weak self] categories in
                guard let self else { return }
                
                let newCategories = categories.compactMap {
                    if case let .category(category) = $0 { return category as (any NoticeTabRepresentable) }
                    else { return nil }
                }
                
                viewControllers = newCategories.compactMap { category in
                    existingViewController(for: category) ?? makeViewController(for: category)
                }
            }
            .bind(to: collectionView.rx.items) { [weak self] (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                
                switch element {
                case let .category(category):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CategoryCell.reuseIdentifier,
                        for: indexPath
                    ) as? CategoryCell else {
                        return UICollectionViewCell()
                    }
                    
                    cell.configure(with: category.tabTitle)
                    
                    return cell
                    
                case .addButton:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: AddButtonCell.reuseIdentifier,
                        for: indexPath
                    ) as? AddButtonCell else {
                        return UICollectionViewCell()
                    }
                    
                    cell.configureAction { [weak self] in
                        self?.showNoticeTabSettings()
                    }
                    
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// Binds collection view item selection to update the selected tab index
    /// and synchronize the page view controller to the corresponding page.
    private func bindCollectionViewSelection() {
        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(CategoryItem.self)
        )
        .bind(onNext: { [weak self] indexPath, element in
            switch element {
            case .category:
                self?.viewModel.selectedIndex.accept(indexPath.row)
            case .addButton:
                self?.collectionView.deselectItem(at: indexPath, animated: false)
            }
        })
        .disposed(by: disposeBag)
    }
    
    /// Synchronizes the selected cell in the collection view whenever the category list
    /// or selected index changes. Runs on `asyncInstance` to ensure `reloadData` has completed.
    private func bindSelectedIndex() {
        Observable.combineLatest(viewModel.categories, viewModel.selectedIndex)
            .observe(on: MainScheduler.asyncInstance)    // reloadData가 완료된 후 실행될 수 있도록 설정
            .subscribe(onNext: { [weak self] categories, targetIndex in
                guard targetIndex < categories.count - 1 else {
                    self?.viewModel.selectedIndex.accept(0)    // 현재 선택된 탭이 삭제되는 경우, 0번 탭으로 이동
                    return
                }
                
                let currentPageIndex: Int = {
                    guard let currentVC = self?.pageViewController.viewControllers?.first,
                          let index = self?.viewControllers.firstIndex(of: currentVC) else {
                        return 0
                    }
                    return index
                }()
                
                let direction: UIPageViewController.NavigationDirection = (targetIndex >= currentPageIndex) ? .forward : .reverse
                
                if let viewController = self?.viewControllers[targetIndex] {
                    self?.pageViewController.setViewControllers([viewController], direction: direction, animated: currentPageIndex != targetIndex)
                }
                
                let targetIndexPath = IndexPath(row: targetIndex, section: 0)
                self?.collectionView.selectItem(
                    at: targetIndexPath,
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
            })
            .disposed(by: disposeBag)
    }
    
    /// Presents the notice tab settings screen as a full-screen modal.
    private func showNoticeTabSettings() {
        guard let view = noticeTabSettingsFactory.make(categoriesRelay: viewModel.categories) else { return }
        
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    public func handle(deepLink: DeepLink) {
        switch deepLink {
        case let .navigation(_, itemIndex):
            if let itemIndex {
                // 전체 개수에서 마지막에 있는 버튼을 제외한 범위
                if (0..<viewModel.categoriesValue.count - 1) ~= itemIndex {
                    // 선택된 탭으로 이동
                    viewModel.selectedIndex.accept(itemIndex)
                } else {
                    // 학과 선택이 되어 있지 않은 경우, 학과 선택 화면으로 이동
                    showNoticeTabSettings()
                }
            }
        default:
            break
        }
    }
    
    private func setLeftBarButtonItem() {
        let titleLabel = UILabel()
        titleLabel.text = "공지"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        let labelItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.leftBarButtonItem = labelItem
        
        if #available(iOS 26, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NoticeTabViewController: UICollectionViewDelegateFlowLayout {
    
    /// Returns the size for each cell based on its type.
    /// Category cells are sized dynamically based on the tab title width;
    /// the add button cell uses a fixed square size.
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let item = viewModel.categoriesValue[indexPath.row]
        
        switch item {
        case let .category(category):
            let font = UIFont.systemFont(ofSize: 15, weight: .medium)
            let textWidth = ceil((category.tabTitle as NSString)
                .size(withAttributes: [.font: font]).width)    // 소숫점 버림에 의해 UI가 잘리지 않도록 `ceil` 적용
            
            return CGSize(width: textWidth + 32, height: 32) // inset 16 * 2
            
        case .addButton:
            return CGSize(width: 32, height: 32)
        }
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension NoticeTabViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    /// Returns the view controller before the given view controller in the page sequence.
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = index - 1
        
        if previousIndex < 0 { return nil }
        
        return viewControllers[previousIndex]
    }
    
    /// Returns the view controller after the given view controller in the page sequence.
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = index + 1
        
        if nextIndex == viewControllers.count { return nil }
        
        return viewControllers[nextIndex]
    }
    
    /// Updates the selected tab index in the view model after a swipe transition completes.
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let viewController = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: viewController) {
            viewModel.selectedIndex.accept(index)
        }
    }
    
}

extension NoticeTabViewController {
    private func existingViewController(
        for category: any NoticeTabRepresentable
    ) -> NoticeCollectionViewController? {
        viewControllers
            .compactMap { $0 as? NoticeCollectionViewController }
            .first { ($0.viewModel.category as? any NoticeTabRepresentable)?.id == category.id }
    }

    private func makeViewController(
        for category: any NoticeTabRepresentable
    ) -> NoticeCollectionViewController? {
        guard let category = category as? any CategoryProtocol else { return nil }
        return noticeCollectionViewControllerFactory.make(for: category)
    }
}

#if DEBUG
struct MockNoticeCollectionViewControllerFactory: NoticeCollectionViewControllerFactory {
    func make(for category: any CategoryProtocol) -> NoticeCollectionViewController? {
        return nil
    }
}

struct MockNoticeTabSettingsFactory: NoticeTabSettingsFactory {
    func make(categoriesRelay: BehaviorRelay<[CategoryItem]>) -> NoticeTabSettings? {
        return nil
    }
}

#Preview {
    NoticeTabViewController(
        noticeCollectionViewControllerFactory: MockNoticeCollectionViewControllerFactory(),
        noticeTabSettingsFactory: MockNoticeTabSettingsFactory()
    )
    .makePreview()
}
#endif
