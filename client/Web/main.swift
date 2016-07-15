import Vapor
import VaporMustache
import VaporUniversity

let mustache = VaporMustache.Provider(withIncludes: [
    "header": "Includes/header.mustache",
    "footer": "Includes/footer.mustache",
])

let drop = Droplet(providers: [mustache])

let database: Database
do {
    database = try VaporUniversityDatabase(drop: drop)
} catch {
    fatalError("Could not initialize Vapor University Database: \(error)")
}

Tutorial.database = database

do {
    if let tutorial = try Tutorial.find(1) {
        print(tutorial.name)
    }
} catch {
    drop.log.error("Error: \(error)")
}


drop.get("/") { request in
    let medium = request.data["medium"].string ?? "video"

    let tutorials = try Tutorial.filter("medium", medium).all().map { tutorial in
        return tutorial.serialize()
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
