import Vapor
import Fluent

public final class Tutorial: Model {
    public var id: Node?
    public var name: String
    public var author: String
    public var medium: String
    public var description: String
    public var image: String
    public var url: String
    public var difficulty: String
    public var duration: Int

    public init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        author = try node.extract("author")
        medium = try node.extract("medium")
        description = try node.extract("description")
        image = try node.extract("image")
        url = try node.extract("url")
        difficulty = (try node.extract("difficulty") as String).uppercaseFirst()
        duration = try node.extract("duration")
    }

    public static func prepare(_ database: Database) throws {
        // not needed for RESTdriver
    }

    public static func revert(_ database: Database) throws {
        // not needed for RESTdriver
    }
}

//MARK: Fluent serializations

extension Tutorial {
    public func makeNode() throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "author": author,
            "description": description,
            "image": image,
            "url": url,
            "difficulty": difficulty,
            "duration": duration,
            "playable": medium == "video" ? true : false
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
