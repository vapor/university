import Vapor
import VaporMySQL

// FIXME: Create ConfigInitializable Providers that can do this automatically
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

// FIXME: Naming issue
typealias Value = FluentValue

let drop = Droplet(providers: [mysql], preparations: [Tutorial.self])

let tutorials = Tutorials()
drop.resource("tutorials", tutorials)

drop.globalMiddleware.append(NotFound())
drop.globalMiddleware.append(Tutorial.Medium.Validator.Middleware()) // FIXME: drop.middleware

drop.serve()
