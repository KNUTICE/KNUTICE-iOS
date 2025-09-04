//
//  KNUTICEWidgetBundle.swift
//  KNUTICEWidget-dev
//
//  Created by 이정훈 on 9/3/25.
//

import KNUTICEWidgetCore
import WidgetKit
import SwiftUI

@main
struct KNUTICEWidgetBundle: WidgetBundle {
    var body: some Widget {
        KNUTICEWidget<SelectNoticeCategoryIntent>(kind: "KNUTICEWidget-dev")
    }
}
