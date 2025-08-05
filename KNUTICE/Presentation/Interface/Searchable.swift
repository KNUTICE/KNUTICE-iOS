//
//  Searchable.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/19/25.
//

import Foundation
import RxRelay

protocol Searchable {
    var bookmarks: BehaviorRelay<[Bookmark]> { get }
    var tasks: [Task<Void, Never>] { get }
    
    func search(with keyword: String)
}
