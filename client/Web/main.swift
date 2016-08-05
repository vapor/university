import Vapor
import VaporMustache
import VaporUniversity

// MARK: Create droplet
let mustache = VaporMustache.Provider(withIncludes: [
    "header": "Includes/header.mustache",
    "footer": "Includes/footer.mustache",
])

let drop = Droplet(initializedProviders: [mustache])

// MARK: Create DB

let database = try VaporUniversityDatabase(drop: drop)
Tutorial.database = database

// MARK: Routes

drop.get("/") { request in
    let medium = request.data["medium"].string ?? "video"

    let tutorials: [[String: String]] = try Tutorial.query().filter("medium", medium).all().map { tutorial in
        var serialized: [String: String] = [:]

        if let obj = try tutorial.makeNode().object {
            for (key, val) in obj {
                serialized[key] = val.string ?? ""
            }
        }


        return serialized
    }

    return try drop.view("Tutorials/index.mustache", context: [
        "tutorials": tutorials,
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

drop.serve()
