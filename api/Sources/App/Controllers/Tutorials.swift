import Vapor
import HTTP

final class Tutorials: ResourceRepresentable {

    func index(request: Request) throws -> ResponseRepresentable {
        var json: [JSON] = []

        let query = try Tutorial.makeQuery()

        if let medium = request.data["medium"]?.string {
            _ = try medium.tested(by: Tutorial.Medium.Validator()) // FIXME: medium.test()
            try query.filter("medium", medium)
        }

        let tutorials = try query.all().sorted { (a, b) in
            if let aid = a.id?.int, let bid = b.id?.int {
                return aid > bid
            } else {
                return false
            }
        }

        for item in tutorials {
            json.append(try item.makeJSON())
        }

        return JSON(json)
    }

    func show(request: Request, item tutorial: Tutorial) throws -> ResponseRepresentable {
        return tutorial
    }

    func makeResource() -> Resource<Tutorial> {
        return Resource(index: index, show: show)
    }
}
