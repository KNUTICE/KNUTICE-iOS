import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNTip",
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNNetwork", path: "../KNNetwork"),
        .project(target: "UIComponents", path: "../UIComponents"),
        .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
        .external(name: "Factory")
    ],
    resources: ["Resources/**"],
)
