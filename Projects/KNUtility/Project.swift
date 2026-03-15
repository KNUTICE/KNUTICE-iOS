import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNUtility",
    dependencies: [
        .external(name: "FirebaseMessaging"),
        .external(name: "FirebaseRemoteConfig"),
        .external(name: "Factory")
    ],
    hasTests: false,
    resources: ["Resources/**"],
)
