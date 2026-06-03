import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNTip",
    dependencies: [
        .project(target: "KNUtility", path: "../../KNUtility"),
        .project(target: "UIComponents", path: "../../UIComponents"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .project(target: "KNDomain", path: "../../KNDomain"),
        .external(name: "Factory")
    ],
    hasTests: false,
)
