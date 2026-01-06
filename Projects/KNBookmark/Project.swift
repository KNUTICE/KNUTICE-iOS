import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNBookmark",
    targets: [
        .target(
            name: "KNBookmark",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.fx.KNBookmark",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "KNNotice", path: "../KNNotice"),
                .project(target: "KNNotification", path: "../KNNotification"),
                .external(name: "RxDataSources")
            ]
        )
    ]
)
