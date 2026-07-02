import ProjectDescription

public extension Project {
    static let marketingVersion: SettingValue = "1.7.4"
    static let appVersion: Plist.Value = "1.7.4"
    static let deploymentTarget: DeploymentTargets = .iOS("17.0")
    
    static func module(
        name: String,
        product: Product = .staticFramework,
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets = Self.deploymentTarget,
        infoPlist: InfoPlist = .default,
        dependencies: [TargetDependency] = [],
        hasTests: Bool = true,
        testDependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        settings: Settings? = .settings(
            base: [
                "OTHER_LDFLAGS": ["-all_load", "-ObjC"],
                "SWIFT_VERSION": "6.0",
                "SWIFT_STRICT_CONCURRENCY": "complete",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "MARKETING_VERSION": marketingVersion
            ]
        )
    ) -> Project {
        let mainBundleId = bundleId ?? "com.fx.\(name)"
        let mainTarget = Target.target(
            name: name,
            destinations: .iOS,
            product: Environment.forPreview.getBoolean(default: false) ? .framework : product,
            bundleId: mainBundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies,
            settings: settings
        )
        
        var targets: [Target] = [mainTarget]
        
        // 테스트 타겟
        if hasTests {
            let testTarget = Target.target(
                name: "\(name)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: mainBundleId + "Tests",
                deploymentTargets: deploymentTargets,
                infoPlist: .default,
                sources: ["Tests/Sources/**"],
                resources: ["Tests/Resources/**"],
                dependencies: testDependencies + [.target(name: name)]
            )
            targets.append(testTarget)
        }
        
        return Project(
            name: name,
            targets: targets
        )
    }
}
