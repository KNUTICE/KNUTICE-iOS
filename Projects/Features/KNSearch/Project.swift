import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNSearch",
    dependencies: [
        .project(target: "KNUtility", path: "../../KNUtility"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .project(target: "CorePresentation", path: "../CorePresentation"),
        .project(target: "KNDomain", path: "../../KNDomain"),
        .project(target: "KNData", path: "../../KNData"),
        .project(target: "KNNotice", path: "../KNNotice"),
        .project(target: "KNBookmark", path: "../KNBookmark"),
        .external(name: "Factory"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "SnapKit"),
        .external(name: "FirebaseAnalytics"),
        .external(name: "ComposableArchitecture"),
    ],
    hasTests: false
)
