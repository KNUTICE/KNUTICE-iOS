import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNReadingRoom",
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNDesignSystem", path: "../KNDesignSystem")
    ],
    resources: ["Resources/**"],
)
