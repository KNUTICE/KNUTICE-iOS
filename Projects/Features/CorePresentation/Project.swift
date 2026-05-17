import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "CorePresentation",
    dependencies: [
        .project(target: "KNDomain", path: "../../KNDomain"),
        .project(target: "KNUtility", path: "../../KNUtility"),
        .external(name: "RxCocoa"),
    ],
    hasTests: false,
    resources: ["Resources/**"],
)
