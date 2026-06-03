import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNDomain",
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNNotification", path: "../KNNotification"),
        .project(target: "KNMarkdown", path: "../KNMarkdown"),
        .external(name: "RxDataSources"),
    ],
)
