//
//  MajorCategoryProvidable.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/5/25.
//

import KNUTICECore

@MainActor
protocol MajorCategoryProvidable {
    associatedtype Category: RawRepresentable<String>
    
    var category: Category? { get set }
}
