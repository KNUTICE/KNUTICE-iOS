import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNDomain",
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .external(name: "RxDataSources"),
    ],
    hasTests: false
)
