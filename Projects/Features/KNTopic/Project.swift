import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNTopic",
    dependencies: [
        .project(target: "KNDomain", path: "../../KNDomain"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .project(target: "UIComponents", path: "../../UIComponents"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Factory")
    ],
    hasTests: false,
)
