//
//  CategoryProtocol.swift
//  KNUTICECore
//
//  Created by 이정훈 on 10/29/25.
//

import Foundation

public protocol CategoryProtocol: RawRepresentable, CaseIterable, Sendable where RawValue == String {
    var localizedDescription: String { get }
}
