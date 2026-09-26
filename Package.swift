// swift-tools-version: 6.2
import PackageDescription

// One target per episode, so each sample builds and previews on its own.
let package = Package(
    name: "TheDetails",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "HeartPopSample", targets: ["HeartPopSample"]),
    ],
    targets: [
        .target(name: "HeartPopSample", path: "episodes/01-heart-pop/Sample"),
    ]
)
