import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNMeal",
    targets: [
        .target(
            name: "KNMeal",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNMeal",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
            ]
        )
    ]
)
