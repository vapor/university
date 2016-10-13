import Vapor
import VaporMySQL

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider.self)

drop.addConfigurable(middleware: NotFound(), name: "not-found")
drop.addConfigurable(middleware: Tutorial.Medium.Validator.Middleware(), name: "medium-validator")

drop.preparations.append(Tutorial.self)

let tutorials = Tutorials()
drop.resource("tutorials", tutorials)

drop.run()
