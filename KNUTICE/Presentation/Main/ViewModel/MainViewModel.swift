//
//  MainViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxSwift
import RxRelay

final class MainViewModel {
    private(set) var notices = BehaviorRelay<[SectionOfNotice]>(value: [])
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    private let repository: MainNoticeRepository
    private let disposeBag = DisposeBag()
    
    init(repository: MainNoticeRepository) {
        self.repository = repository
    }
    
    func getCellValue() -> [SectionOfNotice] {
        return notices.value
    }
    
    func getCellData() -> Observable<[SectionOfNotice]> {
        return notices.asObservable()
    }
    
    func fetchNotices() {
        notices.accept(dummy)
        
        repository.fetchMainNotices()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                //해당 스트림은 MainNoticeRepositoryImpl에서 onComplete()를 호출하기 때문에
                //[weak self]를 굳이 사용하지 않아도 reference count가 증가 되지는 않음.
                self?.notices.accept(result)
            })
            .disposed(by: disposeBag)
    }
    
    func refreshNotices() {
        isLoading.accept(true)
        
        repository.fetchMainNotices()
            .subscribe(onNext: { [weak self] result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.notices.accept(result)
                    self?.isLoading.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private var dummy: [SectionOfNotice] {
        return [
            SectionOfNotice(header: "일반소식",
                            items: Array(repeating: MainNotice(id: UUID().hashValue,
                                                               presentationType: .skeleton,
                                                               title: "temp",
                                                               contentUrl: "temp",
                                                               department: "temp",
                                                               uploadDate: "temp"), count: 3)),
                    
            SectionOfNotice(header: "학사공지",
                            items: Array(repeating: MainNotice(id: UUID().hashValue,
                                                               presentationType: .skeleton,
                                                               title: "temp",
                                                               contentUrl: "temp",
                                                               department: "temp",
                                                               uploadDate: "temp"), count: 3)),
            
            SectionOfNotice(header: "장학공지",
                            items: Array(repeating: MainNotice(id: UUID().hashValue,
                                                               presentationType: .skeleton,
                                                               title: "temp",
                                                               contentUrl: "temp",
                                                               department: "temp",
                                                               uploadDate: "temp"), count: 3)),
                    
            SectionOfNotice(header: "행사안내",
                            items: Array(repeating: MainNotice(id: UUID().hashValue,
                                                               presentationType: .skeleton,
                                                               title: "temp",
                                                               contentUrl: "temp",
                                                               department: "temp",
                                                               uploadDate: "temp"), count: 3))
        ]
    }
}
