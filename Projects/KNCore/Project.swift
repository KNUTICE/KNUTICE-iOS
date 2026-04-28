import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNCore",
    dependencies: [
        .project(target: "KNNotification", path: "../KNNotification"),
        .project(target: "KNNetwork", path: "../KNNetwork"),
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
        .project(target: "UIComponents", path: "../UIComponents"),
        .project(target: "KNTip", path: "../KNTip"),
        .project(target: "KNReport", path: "../KNReport"),
        .project(target: "KNTopic", path: "../KNTopic"),
        .project(target: "KNSetting", path: "../KNSetting"),
        .project(target: "KNIntelligence", path: "../KNIntelligence"),
        .project(target: "KNData", path: "../KNData"),
        .project(target: "KNDomain", path: "../KNDomain"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Factory"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "SnapKit"),
        .external(name: "KingFisher"),
        .external(name: "FirebaseAnalytics"),
    ],
    resources: ["Resources/**"],
)
