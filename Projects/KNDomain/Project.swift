import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNDomain",
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNNotification", path: "../KNNotification"),
        .external(name: "RxDataSources"),
    ],
    hasTests: false
)
