import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNToken",
    dependencies: [
        .external(name: "Factory"),
        .external(name: "FirebaseMessaging"),
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNNetwork", path: "../KNNetwork")
    ],
    resources: ["Resources/**"],
)
