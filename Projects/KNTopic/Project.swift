import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNTopic",
    dependencies: [
        .project(target: "KNNetwork", path: "../KNNetwork"),
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
        .project(target: "UIComponents", path: "../UIComponents"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Factory")
    ],
    hasTests: false,
    resources: ["Resources/**"],
)
