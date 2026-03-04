import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNTip",
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .project(target: "KNNetwork", path: "../KNNetwork"),
        .project(target: "UIComponents", path: "../UIComponents"),
        .external(name: "Factory")
    ],
    resources: ["Resources/**"],
)
