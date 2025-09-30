//
//  MajorNoticeCollectionViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/25/25.
//

import Combine
import KNUTICECore
import RxSwift
import SwiftUI
import UIKit

final class MajorNoticeCollectionViewController: NoticeCollectionViewController<MajorCategory> {    
    lazy var titleButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "학과명"
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 3
        config.contentInsets = .zero
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            return outgoing
        }
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        let button = UIButton(type: .system)
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapTitleButton(_:)), for: .touchUpInside)
        
        return button
    }()
    lazy var stackView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [titleButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .primaryBackground
        
        return stackView
    }()
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackground
        
        if let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> {
            viewModel.bindWithCategory()
        }
    }
    
    override func setupLayout() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(44)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom)
        }
    }
    
    override func bind() {
        super.bind()
        
        if let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> {
            viewModel.$category
                .sink(receiveValue: { [weak self] in
                    self?.titleButton.configuration?.title = $0?.localizedDescription ?? "학과명"
                })
                .store(in: &cancellables)
        }
    }

}

extension MajorNoticeCollectionViewController {
    @objc private func didTapTitleButton(_ sender: UIButton) {
        if let viewModel = viewModel as? NoticeCollectionViewModel<MajorCategory> {
            let viewController = UIHostingController(
                rootView: MajorSelectionView()
                    .environmentObject(viewModel)
            )
            viewController.modalPresentationStyle = .pageSheet
            
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            
            present(viewController, animated: true)
        }
    }
}

#if DEBUG
#Preview {
    MajorNoticeCollectionViewController(viewModel: NoticeCollectionViewModel(category: MajorCategory.computerScience))
        .makePreview()
        .ignoresSafeArea()
}
#endif

