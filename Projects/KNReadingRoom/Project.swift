import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNReadingRoom",
    targets: [
        .target(
            name: "KNReadingRoom",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "com.fx.KNReadingRoom",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                ]
            )
        )
    ]
)
