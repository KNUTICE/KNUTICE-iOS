import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "KNMarkdown",
    product: .staticLibrary,
    dependencies: [
        .project(target: "KNDesignSystem", path: "../KNDesignSystem")
    ],
    hasTests: false
)
