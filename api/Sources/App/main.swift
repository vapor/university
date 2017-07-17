import Vapor
import MySQLProvider

let config = try Config()
try config.addProvider(MySQLProvider.Provider.self)

config.addConfigurable(middleware: NotFound(), name: "not-found")
config.addConfigurable(middleware: Tutorial.Medium.Validator.Middleware(), name: "medium-validator")

config.preparations.append(Tutorial.self)
config.preparations.append(AddVersion.self)

let drop = try Droplet(config)

let tutorials = Tutorials()
drop.resource("tutorials", tutorials)

try drop.run()
