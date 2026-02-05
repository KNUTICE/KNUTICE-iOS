//
//  NoticeContentViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/21/25.
//

import ComposableArchitecture
import Combine
import KNDesignSystem
import KNIntelligence
import KNUtility
import SnapKit
import SwiftUI
import UIKit
import WebKit

enum ABTestLayoutType: String {
    case typeA = "type_A"
    case typeB = "type_B"
}

public final class NoticeContentViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.isHidden = true
        return webView
    }()
    
    private lazy var aiSummarizationButton: UIButton = {
        var config: UIButton.Configuration = {
            if #available(iOS 26, *) { return .glass() }
            return .filled()
        }()
        
        config.baseBackgroundColor = KNDesignSystemAsset.accent2.color
        config.cornerStyle = .capsule
        config.image = KNDesignSystemAsset.knuticeaiLogo.image
            .resizedMaintainingAspectRatio(to: CGSize(width: 35, height: 35))
        
        let action = UIAction { [weak self] _ in self?.presentSummarySheet() }
        let button = UIButton(configuration: config, primaryAction: action)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = .zero
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        
        // MARK: - Symbol Image
        let plusImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        
        // MARK: - Appearance
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        button.layer.shadowOffset = .zero
        
        // MARK: - Interaction
        button.addAction(UIAction { [weak self] _ in
            guard let notice = self?.viewModel.notice else { return }
            
            let bookmark = Bookmark(notice: notice, memo: "")
            let rootView = BookmarkForm(
                store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                    BookmarkFormFeature()
                }
            ) {
                self?.dismiss(animated: true)
            }
            let viewController = UIHostingController(rootView: rootView)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .pageSheet
            
            self?.present(navigationController, animated: true, completion: nil)
        }, for: .touchUpInside)
        
        // MARK: - Style (iOS version specific)
        if #available(iOS 26.0, *) {
            button.tintColor = KNDesignSystemAsset.accent2.color
            button.configuration = .prominentGlass()
        } else {
            button.tintColor = .white
            button.backgroundColor = KNDesignSystemAsset.accent2.color
        }
        
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: NoticeContentViewModel
    private var cancellables = Set<AnyCancellable>()
    private var webViewTask: Task<Void, Never>?
    
    // MARK: - Init
    
    public init(viewModel: NoticeContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        loadInitialData()
        viewModel.fetchLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.noticeTask?.cancel()
        webViewTask?.cancel()
    }
}

// MARK: - Setup Methods

private extension NoticeContentViewController {
    func setupUI() {
        view.backgroundColor = KNDesignSystemAsset.detailViewBackground.color
        
        [webView, aiSummarizationButton, activityIndicator].forEach { view.addSubview($0) }
        
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func bind() {
        // Notice URL 로딩 감시
        viewModel.$notice
            .compactMap { $0?.contentUrl }
            .compactMap { URL(string: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
            }
            .store(in: &cancellables)
        
        viewModel.$layoutType
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] layout in
                switch layout {
                case .typeA:
                    self?.configureLayoutA()
                    
                case .typeB:
                    self?.configureLayoutB()
                }
            })
            .store(in: &cancellables)
    }
    
    func loadInitialData() {
        if let urlString = viewModel.notice?.contentUrl, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else if viewModel.nttId != nil {
            viewModel.fetchNotice()
        }
    }
}

// MARK: - Presentation Actions

private extension NoticeContentViewController {
    func presentSummarySheet() {
        guard let notice = viewModel.notice else { return }
        let summaryViewModel = NoticeSummaryViewModel(nttId: notice.id)
        let rootView = NoticeSummaryView(viewModel: summaryViewModel)
        presentSheet(rootView: rootView)
    }
    
    func presentBookmarkForm() {
        guard let notice = viewModel.notice else { return }
        let bookmark = Bookmark(notice: notice, memo: "")
        let state = BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create)
        
        let rootView = BookmarkForm(
            store: Store(initialState: state) { BookmarkFormFeature() }
        ) { [weak self] in
            self?.dismiss(animated: true)
        }
        
        presentSheet(rootView: rootView)
    }
    
    func presentSheet<Content: View>(rootView: Content) {
        let vc = UIHostingController(rootView: rootView)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
    
    func presentShareSheet() {
        guard let urlStr = viewModel.notice?.contentUrl else { return }
        let activityVC = UIActivityViewController(activityItems: [urlStr], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.completionWithItemsHandler = { [weak self] _, completed, _, _ in
            if completed { self?.showCompletionAlert() }
        }
        present(activityVC, animated: true)
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "알림", message: "공유를 완료했어요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension NoticeContentViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewTask = Task {
            do {
                let _ = try await webView.evaluateJavaScript(JavaScriptScripts.cleanUpKNUTPage)
                webView.isHidden = false
                activityIndicator.stopAnimating()
            } catch {
                print("Failed to configure layout: \(error)")
            }
        }
    }
}

// MARK: - WKUIDelegate

extension NoticeContentViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = action.request.url {
            UIApplication.shared.open(url)
        }
        return nil
    }
}

// MARK: A/B Test
private extension NoticeContentViewController {
    func configureLayoutA() {
        // toolbar
        let shareItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            primaryAction: UIAction { [weak self] _ in self?.presentShareSheet() }
        )
        navigationItem.rightBarButtonItems = [shareItem]
        
        // AI 요약 버튼: 좌측 하단
        aiSummarizationButton.snp.remakeConstraints { make in
            let bottomOffset = UIDevice.current.userInterfaceIdiom == .phone ? -50 : -100
            make.bottom.equalToSuperview().offset(bottomOffset)
            make.leading.equalToSuperview().offset(20) // 좌측
            make.width.height.equalTo(60) // 조금 더 강조된 크기
        }
        
        // 북마크 버튼: 우측 하단 배치
        view.addSubview(bookmarkButton)
        bookmarkButton.snp.remakeConstraints { make in
            let bottomOffset = UIDevice.current.userInterfaceIdiom == .phone ? -50 : -100
            make.bottom.equalToSuperview().offset(bottomOffset)
            make.trailing.equalToSuperview().offset(-20) // 우측
            make.width.height.equalTo(60)
        }
    }
    
    func configureLayoutB() {
        // toolbar
        let shareItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            primaryAction: UIAction { [weak self] _ in self?.presentShareSheet() }
        )
        let bookmarkItem = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            primaryAction: UIAction { [weak self] _ in self?.presentBookmarkForm() }
        )
        navigationItem.rightBarButtonItems = [shareItem, bookmarkItem]
        
        // AI 요약 버튼: 좌측 하단
        aiSummarizationButton.snp.makeConstraints { make in
            let bottomOffset = UIDevice.current.userInterfaceIdiom == .phone ? -50 : -100
            make.bottom.equalToSuperview().offset(bottomOffset)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(50)
        }
    }
}

// MARK: - Constants

private enum JavaScriptScripts {
    static let cleanUpKNUTPage = """
    (function() {
        const hideIds = ['header', 'footer', 'remote', 'foot_layout', 'location', 'snb', 'point'];
        hideIds.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.style.display = 'none';
        });

        document.querySelectorAll(".board_butt").forEach(el => el.style.display = 'none');
        
        document.querySelectorAll(".layout h1").forEach(el => {
            const txt = el.textContent;
            if (txt.includes("학사정보") || txt.includes("커뮤니티")) {
                el.style.display = "none";
            }
        });

        document.documentElement.style.webkitUserSelect = 'none';
        document.documentElement.style.webkitTouchCallout = 'none';
    })();
    """
}
