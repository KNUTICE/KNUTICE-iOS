//
//  NoticeWidgetView.swift
//  KNUTICEWidgetCore
//
//  Created by 이정훈 on 9/3/25.
//

import WidgetKit
import SwiftUI

public struct NoticeWidgetEntryView : View {
    @Environment(\.widgetFamily) private var family: WidgetFamily
    private var entry: Provider.Entry
    
    public init(entry: Provider.Entry) {
        self.entry = entry
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(entry.configuration?.category.rawValue ?? "")
                .font(.headline)
            
            ForEach(entry.notices, id: \.id) { notice in
                if let url = URL(string: "widget://notice?nttId=\(notice.id)") {
                    Link(destination: url) {
                        Text(notice.title)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    // URL 생성 실패 시 fallback
                    Text(notice.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
