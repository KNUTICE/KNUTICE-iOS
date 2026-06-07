import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNDeepLink",
    product: .staticLibrary,
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNDomain", path: "../KNDomain"),
        .external(name: "Factory")
    ],
    hasTests: false
)
