//
//  CustomProgressView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/22/24.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.black)
            .ignoresSafeArea()
            .opacity(0.5)
            .overlay {
                ProgressView()
                    .controlSize(.large)
            }
    }
}

#Preview {
    CustomProgressView()
}
