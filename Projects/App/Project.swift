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
                    "UIBackgroundModes": [
                        "remote-notification"
                    ],
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: "KNUTICE.entitlements"),
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
