import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNReport",
    dependencies: [
        .project(target: "KNDomain", path: "../../KNDomain"),
        .project(target: "KNDesignSystem", path: "../../KNDesignSystem"),
        .external(name: "ComposableArchitecture")
    ],
    hasTests: false,
)
