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
            infoPlist: .extendingDefault(with: [
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
                "CFBundleShortVersionString": "1.7.0"
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: "KNUTICE.entitlements"),
            dependencies: [
                .project(target: "KNCore", path: "../KNCore"),
                .project(target: "KNToken", path: "../KNToken"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNReport", path: "../KNReport"),
                .project(target: "KNDeepLink", path: "../KNDeepLink"),
                .project(target: "KNTip", path: "../KNTip"),
                .project(target: "UIComponents", path: "../UIComponents"),
                .project(target: "KNSetting", path: "../KNSetting"),
                .project(target: "KNReadingRoom", path: "../KNReadingRoom"),
                .external(name: "RxSwift"),
                .external(name: "RxDataSources"),
                .external(name: "Kingfisher"),
                .external(name: "ComposableArchitecture"),
                .external(name: "SnapKit"),
                .external(name: "SkeletonView")
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": ["-all_load", "-ObjC"],
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                ]
            )
        ),
        .target(
            name: "NotificationService",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.fx.KNUTICE.NotificationService",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService",
                ],
            ]),
            sources: ["NotificationService/**"],
            dependencies: [
                .project(target: "KNNotification", path: "../KNNotification")
            ]
        )
    ]
)
