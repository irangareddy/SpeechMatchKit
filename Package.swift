
// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "SpeechMatchKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SpeechMatchKit",
            targets: ["SpeechMatchKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SpeechMatchKit",
            dependencies: []),
        .testTarget(
            name: "SpeechMatchKitTests",
            dependencies: ["SpeechMatchKit"]),
    ]
)
