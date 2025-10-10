//
//  KNUTICEWidgetBundle.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 8/5/25.
//

import KNUTICEWidgetCore
import WidgetKit
import SwiftUI

@main
struct KNUTICEWidgetBundle: WidgetBundle {
    var body: some Widget {
        KNUTICEWidget<SelectNoticeCategoryIntent>(kind: "KNUTICEWidget")
    }
}
