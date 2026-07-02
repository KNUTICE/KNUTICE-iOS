import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNTip",
    dependencies: [
        .project(target: "KNUtility", path: "../../KNUtility"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .project(target: "KNDomain", path: "../../KNDomain"),
        .project(target: "CorePresentation", path: "../CorePresentation"),
        .external(name: "Factory")
    ],
    hasTests: false,
)
