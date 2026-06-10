//
//  BookmarkFormFactory.swift
//  KNNotice
//
//  Created by 이정훈 on 5/6/26.
//

import KNDomain
import SwiftUI
import UIKit

@MainActor
public protocol BookmarkFormFactory {
    associatedtype ContentView: View
    
    func makeSwiftUIView(for notice: Notice, dismissAction: @escaping () -> Void) -> ContentView
    func make(for notice: Notice) -> UIViewController
}
