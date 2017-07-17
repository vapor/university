import Vapor
import FluentProvider

public final class Tutorial: Model, NodeConvertible {
    public var name: String
    public var author: String
    public var medium: String
    public var description: String
    public var image: String
    public var url: String
    public var difficulty: String
    public var duration: Int
    public var version: String
    public let storage = Storage()

    public init(node: Node) throws {
        name = try node.get("name")
        author = try node.get("author")
        medium = try node.get("medium")
        description = try node.get("description")
        image = try node.get("image")
        url = try node.get("url")
        difficulty = (try node.get("difficulty") as String).uppercaseFirst()
        duration = try node.get("duration")
        version = try node.get("version")
        id = try node.get("id")
    }

    public static func prepare(_ database: Database) throws {
        // not needed for RESTdriver
    }

    public static func revert(_ database: Database) throws {
        // not needed for RESTdriver
    }
}

extension Tutorial {
    public convenience init(row: Row) throws {
        try self.init(node: row.makeNode(in: Row.defaultContext))
    }

    public func makeRow() throws -> Row {
        return try makeNode(in: Row.defaultContext).converted()
    }
}

//MARK: Fluent serializations

extension Tutorial {
    public func makeNode(in context: Context?) throws -> Node {
        return try Node(node: [
            "id": id ?? nil,
            "name": name,
            "author": author,
            "description": description,
            "image": image,
            "url": url,
            "difficulty": difficulty,
            "duration": duration,
            "playable": medium == "video" ? true : false,
            "version": version
        ])
    }
}

extension String {
    func uppercaseFirst() -> String {
        var string = self
        guard let first = string.characters.first else {
            return string
        }
        return String(first).uppercased() + String(string.characters.dropFirst())
    }
}
