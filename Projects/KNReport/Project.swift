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
                .project(target: "KNUtility", path: "../KNUtility")
            ]
        )
    ]
)
