import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "TestSupport",
    dependencies: [
        .project(target: "KNDomain", path: "../KNDomain"),
    ],
    hasTests: false,
)
