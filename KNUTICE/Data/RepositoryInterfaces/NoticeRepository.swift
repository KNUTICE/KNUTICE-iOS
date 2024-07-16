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
    func converToNotice(_ dto: ReponseDTO) -> [Notice] {
        return dto.data.map {
            return Notice(id: $0.nttId,
                          boardNumber: $0.contentNumber,
                          title: $0.title,
                          contentUrl: $0.contentUrl,
                          department: $0.departName,
                          uploadDate: $0.registrationDate,
                          imageUrl: $0.contentImage)
        }
    }
}
