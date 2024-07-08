//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift

final class NoticeRepositoryImpl: NoticeRepository {
    private let dataSource: NoticeDataSource
    private let disposeBag = DisposeBag()
    private let remoteURL: String
    
    init(dataSource: NoticeDataSource, remoteURL: String) {
        self.dataSource = dataSource
        self.remoteURL = remoteURL
    }
    
    func fetchNotices() -> Observable<[Notice]> {
        let observable = Observable<[Notice]>.create { observer in
            self.dataSource.fetchNotices(from: self.remoteURL)
                .subscribe(onNext: { [weak self] result in
                    switch result {
                    case .success(let dto):
                        observer.onNext(self?.converToNotice(dto) ?? [])
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
        return observable
    }
    
    func fetchNotices(after number: Int) -> Observable<[Notice]> {
        let observable = Observable<[Notice]>.create { observer in
            self.dataSource.fetchNotices(from: self.remoteURL + "?startBoardNumber=\(number)")
                .subscribe(onNext: { [weak self] result in
                    switch result {
                    case .success(let dto):
                        observer.onNext(self?.converToNotice(dto) ?? [])
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
        return observable
    }
}
