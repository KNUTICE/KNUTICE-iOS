//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift

final class GeneralNoticeRepositoryImpl: GeneralNoticeRepository {
    private let dataSource: GeneralNoticeDataSource
    private let disposeBag = DisposeBag()
    
    init(dataSource: GeneralNoticeDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchNotices() -> Observable<[Notice]> {
        let observable = Observable<[Notice]>.create { observer in
            self.dataSource.fetchNotices()
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
    
    private func converToNotice(_ dto: GeneralNoticeDTO) -> [Notice] {
        return dto.data.map {
            return Notice(id: $0.nttId,
                          title: $0.title,
                          contentURL: $0.contentURL,
                          department: $0.departName,
                          uploadDate: $0.registrationDate)
        }
    }
    
//    func fetchNotices(after number: Int) -> Observable<[Notice]> {
//        
//    }
}
