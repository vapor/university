import PackageDescription

let package = Package(
    name: "VaporUniversity",
    targets: [
        Target(name: "VaporUniversity"),
        Target(name: "Web", dependencies: ["VaporUniversity"])
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 0, minor: 16),
        .Package(url: "https://github.com/vapor/vapor-mustache.git", majorVersion: 0, minor: 11),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

