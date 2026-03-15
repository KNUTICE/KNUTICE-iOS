import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNNetwork",
    product: .staticLibrary,
    dependencies: [
        .project(target: "KNUtility", path: "../KNUtility"),
        .external(name: "Alamofire"),
        .external(name: "RxSwift"),
        .external(name: "Factory"),
        .external(name: "FirebaseMessaging")
    ],
    hasTests: false,
)
