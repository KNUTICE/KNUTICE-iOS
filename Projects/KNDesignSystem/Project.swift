import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNDesignSystem",
    targets: [
        .target(
            name: "KNDesignSystem",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNDesignSystem",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
