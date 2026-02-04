import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "UIComponents",
    targets: [
        .target(
            name: "UIComponents",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.UIComponents",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
