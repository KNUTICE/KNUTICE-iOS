//
//  NoticeViewControllerFactoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/6/26.
//

import ComposableArchitecture
import KNCore
import KNData
import KNDomain
import KNNetwork
import KNNotice
import KNUtility
import SwiftUI

struct NoticeCollectionViewControllerFactoryImpl: NoticeCollectionViewControllerFactory {
    
    func make(for category: any CategoryProtocol) -> NoticeCollectionViewController? {
        let dataSource = RemoteDataSourceImpl()
        let repository = NoticeRepositoryImpl(dataSource: dataSource)
        let usecase = FetchNoticesUseCaseImpl(noticeRepository: repository)
        let viewModel = NoticeCollectionViewModel(category: category, fetchNoticesUseCase: usecase)
        
        return NoticeCollectionViewController(viewModel: viewModel) { notice in
            var hostingController: UIHostingController<BookmarkForm>?
            let bookmark = Bookmark(notice: notice, memo: "")
            let rootView = BookmarkForm(
                store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                    BookmarkFormFeature()
                }
            ) {
                hostingController?.dismiss(animated: true)
            }
            
            hostingController = UIHostingController(rootView: rootView)
            
            return hostingController!
        }
    }
    
}
