import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNNotice",
    targets: [
        .target(
            name: "KNNotice",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNNotice",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .external(name: "Factory"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
            ]
        ),
        .target(
            name: "KNNoticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.fx.KNNotice.tests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["KNNoticeTests/**"],
            dependencies: [
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNNotice", path: "../KNNotice"),
            ]
        )
    ]
)
