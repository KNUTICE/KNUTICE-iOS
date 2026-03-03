import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNUtility",
    dependencies: [
        .external(name: "FirebaseMessaging"),
        .external(name: "FirebaseRemoteConfig"),
        .external(name: "Factory")
    ],
    resources: ["Resources/**"],
)
