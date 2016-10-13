import Vapor
import VaporUniversity
import HTTP

// MARK: Create droplet
let drop = Droplet()

// MARK: Create DB

let database = try VaporUniversityDatabase(drop: drop)
Tutorial.database = database.database

// MARK: Routes

drop.get("/") { request in
    let medium = request.data["medium"]?.string ?? "video"

    let tutorials = try Tutorial.query().filter("medium", medium).all().flatMap({ try $0.makeNode() })
    
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

final class RequestFailedMiddleware: Middleware {
    let drop: Droplet
    init(drop: Droplet) {
        self.drop = drop
    }

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch RESTDriver.Error.requestFailed(let error) {
            let message: String

            if drop.environment == .production {
                message = "Something went wrong, please try again later."
            } else {
                message = "Request Failed: \(error)"
            }

            return try drop.view.make("error", [
                "message": message
            ]).makeResponse()
        }
    }
}

drop.middleware.append(RequestFailedMiddleware(drop: drop))

drop.run()
