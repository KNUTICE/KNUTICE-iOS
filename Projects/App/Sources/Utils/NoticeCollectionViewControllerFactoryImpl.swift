//
//  NoticeViewControllerFactoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/6/26.
//

import KNData
import KNDomain
import KNNetwork
import KNNotice
import KNUtility

struct NoticeCollectionViewControllerFactoryImpl: NoticeCollectionViewControllerFactory {
    
    func make(for category: any CategoryProtocol) -> NoticeCollectionViewController? {
        let dataSource = RemoteDataSourceImpl()
        let repository = NoticeRepositoryImpl(dataSource: dataSource)
        let usecase = FetchNoticesUseCaseImpl(noticeRepository: repository)
        let viewModel = NoticeCollectionViewModel(category: category, fetchNoticesUseCase: usecase)
        
        return NoticeCollectionViewController(viewModel: viewModel, bookmarkFormFactory: BookmarkFormFactoryImpl())
    }
    
}
