//
//  View+Fork.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/10/24.
//

import SwiftUI

extension View {
    func fork<V: View>(@ViewBuilder _ merge: (Self) -> V) -> V { merge(self) }
}
