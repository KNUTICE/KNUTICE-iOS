import ProjectDescription

public extension Project {
    static let appVersion: SettingValue = "1.7.0"
    
    static func module(
        name: String,
        product: Product = .staticFramework,
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets = .iOS("17.0"),
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
                "MARKETING_VERSION": appVersion
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
