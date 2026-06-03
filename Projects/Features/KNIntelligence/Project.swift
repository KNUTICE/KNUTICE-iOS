import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNIntelligence",
    dependencies: [
        .project(target: "KNNetwork", path: "../../KNNetwork"),
        .project(target: "KNUtility", path: "../../KNUtility"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .project(target: "KNMarkdown", path: "../../KNMarkdown"),
        .project(target: "KNDomain", path: "../../KNDomain"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Factory")
    ],
    hasTests: false,
    resources: ["Resources/**"],
)
