import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNSetting",
    dependencies: [
        .project(target: "KNReport", path: "../Features/KNReport"),
        .project(target: "KNTopic", path: "../KNTopic"),
        .project(target: "UIComponents", path: "../UIComponents"),
        .external(name: "ComposableArchitecture")
    ],
    hasTests: false,
    resources: ["Resources/**"],
)
