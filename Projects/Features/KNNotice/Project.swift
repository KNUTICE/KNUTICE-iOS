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
        .external(name: "ComposableArchitecture"),
        .external(name: "Factory"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "SnapKit"),
        .external(name: "KingFisher"),
    ],
    hasTests: false
)
