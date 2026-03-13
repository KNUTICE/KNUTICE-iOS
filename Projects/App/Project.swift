import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "KNUTICE",
    targets: [
        .target(
            name: "KNUTICE",
            destinations: .iOS,
            product: .app,
            bundleId: "com.fx.KNUTICE",
            deploymentTargets: Project.deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "NSAppTransportSecurity": [
                    "NSAllowsArbitraryLoads": true
                ],
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
                "CFBundleShortVersionString": Project.appVersion
            ]),
            sources: ["Sources/**"],
            resources: [
                .glob(pattern: "Resources/**", excluding: [
                    "Resources/*.entitlements"
                ])
            ],
            entitlements: .file(path: "Resources/KNUTICE.entitlements"),
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
                .project(target: "KNMeal", path: "../KNMeal"),
                .target(name: "NotificationService"),
                .target(name: "KNUTICEWidget"),
                .external(name: "RxSwift"),
                .external(name: "RxDataSources"),
                .external(name: "Kingfisher"),
                .external(name: "ComposableArchitecture"),
                .external(name: "SnapKit"),
                .external(name: "SkeletonView"),
                .external(name: "FirebaseAnalytics"),
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": ["-all_load", "-ObjC"],
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                    "LOCALIZED_STRING_SWIFT_SYMBOLS_GENERATION": "YES",
                    "MARKETING_VERSION": Project.marketingVersion
                ]
            )
        ),
        .target(
            name: "NotificationService",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.fx.KNUTICE.NotificationService",
            deploymentTargets: Project.deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "CFBundleShortVersionString": Project.appVersion,
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService",
                ],
            ]),
            sources: ["NotificationService/Sources/**"],
            resources: [
                .glob(pattern: "NotificationService/Resources", excluding: [
                    "NotificationService/Resources/*.entitlements"
                ])
            ],
            entitlements: .file(path: "NotificationService/Resources/NotificationService.entitlements"),
            dependencies: [
                .project(target: "KNNotification", path: "../KNNotification")
            ]
        ),
        .target(
            name: "KNUTICEWidget",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.fx.KNUTICE.widget",
            deploymentTargets: Project.deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "KNUTICE",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ],
                "CFBundleShortVersionString": Project.appVersion
            ]),
            sources: ["Widget/Sources/**"],
            resources: [
                .glob(pattern: "Widget/Resources/**", excluding: [
                    "Widget/Resources/*.entitlements"
                ])
            ],
            entitlements: .file(path: "Widget/Resources/Widget.entitlements"),
            dependencies: [
                .project(target: "KNCore", path: "../KNCore"),
            ],
            settings: .settings(
                base: [
                    "MARKETING_VERSION": Project.marketingVersion
                ]
            )
        )
    ]
)
