import Vapor
import VaporMySQL

let _d = Droplet()
let config = _d.config

guard
    let host = config["database", "default", "host"].string,
    let user = config["database", "default", "user"].string,
    let password = config["database", "default", "password"].string,
    let database = config["database", "default", "database"].string
else {
    throw Abort.badRequest
}

let mysql = try VaporMySQL.Provider(
    host: host,
    user: user,
    password: password,
    database: database
)

let drop = Droplet(providers: [mysql], preparations: [Tutorial.self])


let tutorials = Tutorials()
drop.resource("tutorials", tutorials)

class NotFoundMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch Abort.notFound {
            throw Abort.custom(status: .notFound, message: "Resource not found.")
        }
    }
}

drop.globalMiddleware.append(NotFoundMiddleware())
drop.globalMiddleware.append(Tutorial.Medium.Validator.Middleware()) // FIXME: drop.middleware

drop.serve()
