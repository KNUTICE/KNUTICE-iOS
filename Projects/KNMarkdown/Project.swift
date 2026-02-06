import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNMarkdown",
    targets: [
        .target(
            name: "KNMarkdown",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNMarkdown",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
            ],
        )
    ]
)
