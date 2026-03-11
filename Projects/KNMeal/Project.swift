import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNMeal",
    dependencies: [
        .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
        .project(target: "KNUtility", path: "../KNUtility"),
    ],
    resources: ["Resources/**"],
)
