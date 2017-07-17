import Vapor
import VaporUniversity
import HTTP
import LeafProvider

var config = try Config()

config.addConfigurable(
    middleware: RequestFailedMiddleware(env: config.environment),
    name: "request-failed"
)

try config.addProvider(LeafProvider.Provider.self)

// MARK: Create droplet
let drop = try Droplet(config)

// MARK: Create DB

let database = try VaporUniversityDatabase(drop: drop)
Tutorial.database = database.database

// MARK: Routes

drop.get("/") { request in
    let medium = request.data["medium"]?.string ?? "video"

    let tutorials = try Tutorial
        .makeQuery()
        .filter("medium", medium)
        .all().flatMap({
            try $0.makeNode(in: nil)
        })
    
    return try drop.view.make("Tutorials/index", [
        "tutorials": Node.array(tutorials),
        "mediums": [
            [
                "url": "video",
                "class": medium == "video" ? "active" : "",
                "text": "📽"
            ],
            [
                "url": "article",
                "class": medium == "article" ? "active" : "",
                "text": "📖"
            ]
        ]
    ])
}

try drop.run()
