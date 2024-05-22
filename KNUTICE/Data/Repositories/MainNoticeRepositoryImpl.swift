//
//  MainNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift

final class MainNoticeRepositoryImpl: MainNoticeRepository {
    private let dataSource: MainNoticeDataSource
    private let disposeBag = DisposeBag()
    
    init(dataSource: MainNoticeDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchMainNotices() -> Observable<[SectionOfNotice]> {
        let observable = Observable<[SectionOfNotice]>.create { observer in
            self.dataSource.fetchMainNotices().subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let result):
                    observer.onNext(self?.convertToNotice(result) ?? [])
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                    observer.onCompleted()
                }
            })
            .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
        return observable
    }
    
    private func convertToNotice(_ dto: MainNoticeDTO) -> [SectionOfNotice] {
        var sectionOfNotices = [SectionOfNotice]()
        
        //일반공지
        sectionOfNotices.append(
            SectionOfNotice(header: "일반공지",
                            items: dto.data.generalNewsTopThreeTitle.map {
                                Notice(id: $0.nttId,
                                       title: $0.title,
                                       contentURL: $0.contentURL,
                                       department: $0.departName,
                                       uploadDate: $0.registrationDate)
                            })
        )
        
        //학사공지
        sectionOfNotices.append(
            SectionOfNotice(header: "학사공지",
                            items: dto.data.academicNewsTopThreeTitle.map {
                                Notice(id: $0.nttId,
                                       title: $0.title,
                                       contentURL: $0.contentURL,
                                       department: $0.departName,
                                       uploadDate: $0.registrationDate)
                            })
        )
        
        //장학공지
        sectionOfNotices.append(
            SectionOfNotice(header: "장학공지",
                            items: dto.data.scholarshipNewsTopThreeTitle.map {
                                Notice(id: $0.nttId,
                                       title: $0.title,
                                       contentURL: $0.contentURL,
                                       department: $0.departName,
                                       uploadDate: $0.registrationDate)
                            })
        )
        
        //행사안내
        sectionOfNotices.append(
            SectionOfNotice(header: "행사안내",
                            items: dto.data.eventNewsTopThreeTitle.map {
                                Notice(id: $0.nttId,
                                       title: $0.title,
                                       contentURL: $0.contentURL,
                                       department: $0.departName,
                                       uploadDate: $0.registrationDate)
                            })
        )
        
        return sectionOfNotices
    }
}
