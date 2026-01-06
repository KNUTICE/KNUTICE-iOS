import ProjectDescription

let project = Project(
    name: "KNUTICE",
    targets: [
        .target(
            name: "KNUTICE",
            destinations: .iOS,
            product: .app,
            bundleId: "com.fx.KNUTICE",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNNotice", path: "../KNNotice"),
                .project(target: "KNBookmark", path: "../KNBookmark"),
                .project(target: "KNToken", path: "../KNToken"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNReport", path: "../KNReport"),
                .project(target: "KNDeepLink", path: "../KNDeepLink"),
                .project(target: "KNTip", path: "../KNTip"),
                .external(name: "RxSwift"),
                .external(name: "RxDataSources"),
                .external(name: "Kingfisher"),
                .external(name: "ComposableArchitecture"),
                .external(name: "SnapKit"),
                .external(name: "SkeletonView")
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": ["-all_load", "-ObjC"]
                ]
            )
        ),
    ]
)
