import Vapor
import HTTP
import FluentProvider

final class Tutorial: Model, NodeConvertible {
    var name: String
    var author: String
    var medium: Medium
    var image: String
    var url: String
    var description: String
    var duration: Int
    var difficulty: Difficulty
    var version: String
    var storage: Storage

    init(node: Node) throws {
        name = try node.get("name")
        author = try node.get("author")
        medium = try Medium(node: node.get("medium"))
        image = node["image"]?.string ?? "sample-tile.png"
        url = try node.get("url")
        description = try node.get("description")
        duration = try node.get("duration")
        difficulty = try Difficulty(node: node.get("difficulty"))
        version = try node.get("version")
        self.storage = Storage()
        id = try node.get("id")
    }
}

extension Tutorial {
    convenience init(row: Row) throws {
        try self.init(node: row.makeNode(in: Row.defaultContext))
    }

    func makeRow() throws -> Row {
        return try makeNode(in: Row.defaultContext).converted()
    }
}

// MARK: Fluent Serialization

extension Tutorial {
    func makeNode(in context: Context?) throws -> Node {
        return try Node(node: [
            "id": id ?? nil,
            "name": name,
            "author": author,
            "medium": medium,
            "image": image,
            "url": url,
            "description": description,
            "duration": duration,
            "difficulty": difficulty,
            "version": version
        ])
    }
}

// MARK: Preparations

extension Tutorial: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { tutorials in
            tutorials.id()
            tutorials.string("name")
            tutorials.string("medium")
            tutorials.string("image")
            tutorials.string("url")
            tutorials.string("description")
            tutorials.int("duration")
            tutorials.string("difficulty")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: Temporary error

extension Tutorial {
    enum Error: Swift.Error {
        case databaseParseError(String)
    }
}

extension Tutorial: JSONRepresentable {
    func makeJSON() throws -> JSON {
        return try makeNode(in: JSON.defaultContext).converted()
    }
}

extension Tutorial: ResponseRepresentable {

}
