//
//  Container+Instance.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/6/26.
//

import Factory
import KNBookmark
import KNData
import KNDomain
import KNNetwork
import KNTip

extension Container {
    // MARK: - Repository
    var noticeRepository: Factory<NoticeRepository> {
        Factory(self) { NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl()) }
    }
    
    var bookmarkRepository: Factory<BookmarkRepository> {
        Factory(self) { BookmarkRepositoryImpl.shared }
    }
    
    var reportRepository: Factory<ReportRepository> {
        Factory(self) { ReportRepositoryImpl() }
    }
    
    var tipRepository: Factory<TipRepository> {
        Factory(self) { TipRepositoryImpl() }
    }
    
    var topicSubscriptionRepository: Factory<TopicSubscriptionRepository> {
        Factory(self) { TopicSubscriptionRepositoryImpl() }
    }
    
    //MARK: - UseCase
    var fetchBookmarksUseCase: Factory<FetchBookmarksUseCase> {
        Factory(self) { FetchBookmarksUseCaseImpl(bookmarkReportory: self.bookmarkRepository()) }
    }
    
    var deleteBookmarkUseCase: Factory<DeleteBookmarkUseCase> {
        Factory(self) { DeleteBookmarkUseCaseImpl(bookmarkRepository: self.bookmarkRepository()) }
    }
    
    var saveBookmarkUseCase: Factory<SaveBookmarkUseCase> {
        Factory(self) { SaveBookmarkUseCaseImpl(bookmarkRepository: self.bookmarkRepository()) }
    }
    
    var providerReloadEventPublisherUseCase: Factory<ProvideReloadEventPublisherUseCase> {
        Factory(self) { ProvideReloadEventPublisherUseCaseImpl(repository: self.bookmarkRepository()) }
    }
    
    var fetchTipUseCase: Factory<FetchTipUseCase> {
        Factory(self) { FetchTipUseCaseImpl(repository: self.tipRepository()) }
    }
    
    var fetchTopThreeNoticesUseCase: Factory<FetchTopThreeNoticesUseCase> {
        Factory(self) { FetchTopThreeNoticesUseCaseImpl(repository: self.noticeRepository()) }
    }
    
    var fetchNoticesUseCase: Factory<FetchNoticesUseCase> {
        Factory(self) { FetchNoticesUseCaseImpl(noticeRepository: self.noticeRepository()) }
    }
    
    var updateBookmarkUseCase: Factory<UpdateBookmarkUseCase> {
        Factory(self) { UpdateBookmarkUseCaseImpl(bookmarkRepository: self.bookmarkRepository()) }
    }
    
    var submitReportUseCase: Factory<SubmitReportUseCase> {
        Factory(self) { SubmitReportUseCaseImpl(repository: self.reportRepository()) }
    }
    
    var fetchTopicSubscriptionUseCase: Factory<FetchTopicSubscriptionsUseCase> {
        Factory(self) { FetchTopicSubscriptionsUseCaseImpl(repository: self.topicSubscriptionRepository()) }
    }
    
    var updateTopicSubscriptionUseCase: Factory<UpdateTopicSubscriptionUseCase> {
        Factory(self) { UpdateTopicSubscriptionUseCaseImpl(repository: self.topicSubscriptionRepository()) }
    }
    
    
    //MARK: - ViewModel
    
    @MainActor
    var bookmarkTableViewModel: Factory<BookmarkTableViewModel> {
        Factory(self) {
            MainActor.assumeIsolated {
                BookmarkTableViewModel(
                    fetchBookmarksUseCase: self.fetchBookmarksUseCase(),
                    providerReloadEventPublisherUseCase: self.providerReloadEventPublisherUseCase(),
                    deleteBookmarkUseCase: self.deleteBookmarkUseCase()
                )
            }
        }
    }

    @MainActor
    var parentViewModel: Factory<ParentViewModel> {
        .mainActor(self) { ParentViewModel() }
    }
}
