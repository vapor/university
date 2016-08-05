import Vapor
import VaporMySQL

let drop = Droplet(preparations: [Tutorial.self], providers: [VaporMySQL.Provider.self])

let tutorials = Tutorials()
drop.resource("tutorials", tutorials)

drop.middleware.append(NotFound())
drop.middleware.append(Tutorial.Medium.Validator.Middleware())

drop.serve()
