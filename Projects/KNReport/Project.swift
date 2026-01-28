import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNReport",
    targets: [
        .target(
            name: "KNReport",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNReport",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
                .external(name: "ComposableArchitecture")
            ]
        ),
        .target(
            name: "KNReportTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.fx.KNReport.tests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["KNReportTests/**"],
            dependencies: [
                .project(target: "KNReport", path: "../KNReport"),
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "KNUtility", path: "../KNUtility"),
            ]
        ),
    ]
)
