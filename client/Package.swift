import PackageDescription

let package = Package(
    name: "VaporUniversity",
    targets: [
        Target(name: "VaporUniversity"),
        Target(name: "Web", dependencies: ["VaporUniversity"])
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1)
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

