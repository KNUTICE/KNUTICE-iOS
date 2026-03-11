import ProjectDescription

public extension Project {
    static let marketingVersion: SettingValue = "1.7.0"
    static let appVersion: Plist.Value = "1.7.0"
    static let deploymentTarget: DeploymentTargets = .iOS("17.0")
    
    static func module(
        name: String,
        product: Product = .staticFramework,
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets = Self.deploymentTarget,
        infoPlist: InfoPlist = .default,
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        settings: Settings? = .settings(
            base: [
                "OTHER_LDFLAGS": ["-all_load", "-ObjC"],
                "SWIFT_VERSION": "6.0",
                "SWIFT_STRICT_CONCURRENCY": "complete",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                "LOCALIZED_STRING_SWIFT_SYMBOLS_GENERATION": "YES",
                "MARKETING_VERSION": marketingVersion
            ]
        )
    ) -> Project {
        return Project(
            name: name,
            targets: [
                .target(
                    name: name,
                    destinations: .iOS,
                    product: Environment.forPreview.getBoolean(default: false) ? .framework : product,
                    bundleId: bundleId ?? "com.fx.\(name)",
                    deploymentTargets: deploymentTargets,
                    infoPlist: infoPlist,
                    sources: sources,
                    resources: resources,
                    dependencies: dependencies,
                    settings: settings
                )
            ]
        )
    }
}
