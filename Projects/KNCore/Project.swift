import ProjectDescription

let infoPlist: [String: Plist.Value] = [:]
let project = Project(
    name: "KNCore",
    targets: [
        .target(
            name: "KNCore",
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : .staticFramework,
            bundleId: "com.fx.KNCore",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "KNNotification", path: "../KNNotification"),
                .project(target: "KNNetwork", path: "../KNNetwork"),
                .project(target: "KNUtility", path: "../KNUtility"),
                .project(target: "KNDesignSystem", path: "../KNDesignSystem"),
                .project(target: "UIComponents", path: "../UIComponents"),
                .project(target: "KNTip", path: "../KNTip"),
                .project(target: "KNReport", path: "../KNReport"),
                .project(target: "KNTopic", path: "../KNTopic"),
                .project(target: "KNSetting", path: "../KNSetting"),
                .project(target: "KNIntelligence", path: "../KNIntelligence"),
                .external(name: "ComposableArchitecture"),
                .external(name: "Factory"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxDataSources"),
                .external(name: "SnapKit"),
                .external(name: "KingFisher"),
            ],
        )
    ]
)
