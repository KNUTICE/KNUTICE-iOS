import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNReport",
    dependencies: [
        .project(target: "KNNetwork", path: "../KNNetwork"),
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
        .external(name: "ComposableArchitecture")
    ],
    resources: ["Resources/**"],
)
