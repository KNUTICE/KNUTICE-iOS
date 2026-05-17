import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNNotice",
    dependencies: [
        .project(target: "KNUtility", path: "../../KNUtility"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .project(target: "UIComponents", path: "../../UIComponents"),
        .project(target: "CorePresentation", path: "../CorePresentation"),
        .project(target: "KNDomain", path: "../../KNDomain"),
        .project(target: "KNTopic", path: "../../KNTopic"),
        .project(target: "KNDeepLink", path: "../../KNDeepLink"),
        .project(target: "KNIntelligence", path: "../../KNIntelligence"),
        .project(target: "KNData", path: "../../KNData"),
        .project(target: "KNSetting", path: "../../KNSetting"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Factory"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "SnapKit"),
        .external(name: "KingFisher"),
        .external(name: "FirebaseAnalytics"),
    ],
    testDependencies: [
        .project(target: "TestSupport", path: "../../TestSupport"),
    ]
)
