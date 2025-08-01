//
//  NoticeSectionModelProvidable.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import Foundation
import RxRelay

protocol NoticeSectionModelProvidable {
    var notices: BehaviorRelay<[NoticeSectionModel]> { get }
}
