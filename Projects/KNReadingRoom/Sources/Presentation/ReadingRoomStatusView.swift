//
//  ReadingRoomStatusView.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 2/1/26.
//

import SwiftUI

public struct ReadingRoomStatusView: UIViewControllerRepresentable {
    public init() {}
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = ReadingRoomStatusViewController()
        
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: some UIViewController, context: Context) {}
}

#Preview {
    ReadingRoomStatusView()
}
