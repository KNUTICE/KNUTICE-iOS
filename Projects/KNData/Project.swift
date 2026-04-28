import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNData",
    dependencies: [
        .project(target: "KNNetwork", path: "../KNNetwork"),
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNDomain", path: "../KNDomain"),
    ],
    hasTests: false,
    resources: ["Resources/**"],
)
