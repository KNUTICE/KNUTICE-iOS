import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNBookmark",
    dependencies: [
        .project(target: "KNNotification", path: "../../KNNotification"),
        .project(target: "KNUtility", path: "../../KNUtility"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .project(target: "UIComponents", path: "../../UIComponents"),
        .project(target: "KNData", path: "../../KNData"),
        .project(target: "KNDomain", path: "../../KNDomain"),
        .project(target: "KNNotice", path: "../KNNotice"),
        .project(target: "CorePresentation", path: "../CorePresentation"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Factory"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "SnapKit"),
        .external(name: "FirebaseAnalytics"),
    ],
    hasTests: false,
)
