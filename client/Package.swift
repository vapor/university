import PackageDescription

let package = Package(
    name: "VaporUniversity",
    dependencies: [
        .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 14),
        .Package(url: "https://github.com/qutheory/vapor-mustache.git", majorVersion: 0, minor: 10),
    ],
	targets: [
        Target(name: "VaporUniversity"),
		Target(name: "Web", dependencies: ["VaporUniversity"])
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

