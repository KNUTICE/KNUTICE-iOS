//
//  ToolbarContent+Fork.swift
//  KNUtility
//
//  Created by 이정훈 on 2/24/26.
//

import SwiftUI

public extension ToolbarContent {
    func fork<Content: ToolbarContent>(@ToolbarContentBuilder transform: (Self) -> Content) -> some ToolbarContent {
        transform(self)
    }
}
