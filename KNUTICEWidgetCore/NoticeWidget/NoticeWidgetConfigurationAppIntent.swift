//
//  NoticeWidgetConfigurationAppIntent.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 8/5/25.
//

import AppIntents
import KNUTICECore
import WidgetKit

public protocol SelectNoticeCategoryIntentInterface: WidgetConfigurationIntent {
    associatedtype T: AppEnum & RawRepresentable<String> & NoticeCategoryMappable
    
    var category: T { get }
}
