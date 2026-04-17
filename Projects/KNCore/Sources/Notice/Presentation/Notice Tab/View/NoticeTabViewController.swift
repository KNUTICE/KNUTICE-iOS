//
//  NoticeTabViewController.swift
//  KNCore
//
//  Created by 이정훈 on 4/10/26.
//

import KNDesignSystem
import KNUtility
import UIKit
import RxSwift
import SnapKit
import SwiftUI

public final class NoticeTabViewController: UIViewController {
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
    
    /// List of view controllers corresponding to each category tab.
    private var viewControllers: [UIViewController] = []
    
    /// View model managing category data and selected tab index.
    private let viewModel: NoticeTabViewModel = NoticeTabViewModel()
    
    /// Dispose bag for managing RxSwift subscriptions.
    private let disposeBag: DisposeBag = .init()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        setupCollectionViewLayout()
        setupPageViewLayout()
        bindCollectionView()
        bindCollectionViewSelection()
        bindSelectedIndex()
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
                let newCategories = categories.compactMap {
                    if case let .category(category) = $0 { return category as (any NoticeTabRepresentable) }
                    else { return nil }
                }
                
                self?.viewControllers = newCategories.map { category in
                    self?.viewControllers
                        .compactMap { $0 as? NoticeCollectionViewController }
                        .first { ($0.viewModel.category as? any NoticeTabRepresentable)?.id == category.id }
                    ?? NoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: category as? any CategoryProtocol))
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
                guard targetIndex < categories.count else { return }
                
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
        let view = NoticeTabSettings()
            .environment(NoticeTabItems(viewModel.categories))
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true, completion: nil)
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

#if DEBUG
#Preview {
    NoticeTabViewController()
        .makePreview()
}
#endif
