//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift

protocol NoticeRepository {
    func fetchNotices() -> Observable<[Notice]>
    func fetchNotices(after number: Int) -> Observable<[Notice]>
}

extension NoticeRepository {    
    func converToNotice(_ dto: NoticeReponseDTO) -> [Notice] {
        return dto.body.map {
            return Notice(id: $0.nttID,
                          boardNumber: $0.contentNumber,
                          title: $0.title,
                          contentUrl: $0.contentURL,
                          department: $0.departName,
                          uploadDate: $0.registeredAt,
                          imageUrl: $0.contentImage)
        }
    }
}
