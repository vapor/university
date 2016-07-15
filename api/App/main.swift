import Vapor
import VaporMySQL

let config = try Config(workingDirectory: "./")
let user = config["database", "default", "user"] // FIXME: VaporMySQL should take care of this

guard
    let host = config["database", "default", "password"].string,
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

drop.globalMiddleware.append(Tutorial.Medium.Validator.Middleware()) // FIXME: drop.middleware

drop.serve()
