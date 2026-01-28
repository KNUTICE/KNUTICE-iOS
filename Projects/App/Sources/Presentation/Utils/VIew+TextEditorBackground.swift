//
//  VIew+TextEditorBackground.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import SwiftUI

extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
