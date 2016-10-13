import Vapor
import HTTP
import Fluent

final class Tutorial: Model {
    var id: Node?
    var name: String
    var author: String
    var medium: Medium
    var image: String
    var url: String
    var description: String
    var duration: Int
    var difficulty: Difficulty
    var exists: Bool = false

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        author = try node.extract("author")
        medium = try Medium(node: try node.extract("medium"))
        image = node["image"]?.string ?? "sample-tile.png"
        url = try node.extract("url")
        description = try node.extract("description")
        duration = try node.extract("duration")
        difficulty = try Difficulty(node: try node.extract("difficulty"))
    }
}

// MARK: Fluent Serialization

extension Tutorial {
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "author": author,
            "medium": medium,
            "image": image,
            "url": url,
            "description": description,
            "duration": duration,
            "difficulty": difficulty
        ])
    }
}

// MARK: Preparations

extension Tutorial {
    static func prepare(_ database: Database) throws {
        try database.create("tutorials") { tutorials in
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
        try database.delete("tutorials")
    }
}

// MARK: Temporary error

extension Tutorial {
    enum Error: Swift.Error {
        case databaseParseError(String)
    }
}
