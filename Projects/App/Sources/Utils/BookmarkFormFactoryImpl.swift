//
//  BookmarkFormFactoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/6/26.
//

import ComposableArchitecture
import KNCore
import KNDomain
import KNNotice
import SwiftUI
import UIKit

struct BookmarkFormFactoryImpl: BookmarkFormFactory {
    
    func make(for notice: Notice) -> UIViewController {
        var hostingController: UIHostingController<BookmarkForm>?
        let bookmark = Bookmark(notice: notice, memo: "")
        let rootView = BookmarkForm(
            store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                BookmarkFormFeature()
            }
        ) {
            hostingController?.dismiss(animated: true)
        }
        
        hostingController = UIHostingController(rootView: rootView)
        
        return hostingController!
    }
}
