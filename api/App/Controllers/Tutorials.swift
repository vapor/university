import Vapor

final class Tutorials: Resource {

    func index(request: Request) throws -> ResponseRepresentable {
        var json: [JSON] = []

        let query = Tutorial.query

        if let medium = request.data["medium"].string {
            _ = try medium.tested(by: Tutorial.Medium.Validator.self) // FIXME: medium.test()
            query.filter("medium", medium)
        }

        for item in try query.all() {
            json.append(item.makeJSON())
        }

        return JSON(json)
    }

    func show(request: Request, item tutorial: Tutorial) throws -> ResponseRepresentable {
        return tutorial
    }

}
