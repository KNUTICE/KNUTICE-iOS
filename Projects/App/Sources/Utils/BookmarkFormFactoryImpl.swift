//
//  BookmarkFormFactoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/6/26.
//

import ComposableArchitecture
import KNBookmark
import KNDomain
import KNNotice
import SwiftUI
import UIKit

struct BookmarkFormFactoryImpl: BookmarkFormFactory {
    
    func make(for notice: Notice) -> UIViewController {
        let bookmark = Bookmark(notice: notice, memo: "")
        let hostingController = UIHostingController<BookmarkForm?>(rootView: nil)
        hostingController.rootView = BookmarkForm(
            store: Store(initialState: BookmarkFormFeature.State(bookmark: bookmark, original: bookmark, formType: .create) ) {
                BookmarkFormFeature()
            }
        ) { [weak hostingController] in
            hostingController?.dismiss(animated: true)
        }
        
        return hostingController
    }
}
