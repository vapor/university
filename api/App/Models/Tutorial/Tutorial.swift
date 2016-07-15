import Vapor
import Fluent

final class Tutorial: Vapor.Model {
    var id: Value?
    var name: String
    var medium: Medium
    var image: String
    var url: String
    var description: String
    var duration: Int
    var difficulty: Difficulty

    init(serialized: [String: Value]) { // FIXME: init(Value)
        id = serialized["id"]
        name = serialized["name"].string ?? ""
        medium = try! Medium(serialized["medium"]!)
        image = serialized["image"].string ?? "sample-tile.png"
        url = serialized["url"].string ?? ""
        description = serialized["description"].string ?? ""
        duration = serialized["duration"].int ?? 0
        difficulty = try! Difficulty(serialized["difficulty"]!)
    }
}

// MARK: Fluent Serialization

extension Tutorial {
    func serialize() -> [String: Value?] { // FIXME: ValueRepresentable
        return [
            "id": id,
            "name": name,
            "medium": try! medium.value(), // FIXME: not throwing
            "image": image,
            "url": url,
            "description": description,
            "duration": duration,
            "difficulty": try! difficulty.value()
        ]
    }
}

// MARK: Preparations

extension Tutorial {
    static func prepare(database: Database) throws {
        try database.create("tutorials") { tutorials in
            tutorials.id()
            tutorials.string("name")
            tutorials.string("medium") // FIXME: enum support
            tutorials.string("image")
            tutorials.string("url")
            tutorials.string("description")
            tutorials.int("duration") // FIXME: TEXT support
            tutorials.string("difficulty") // FIXME: enum support
        }
    }

    static func revert(database: Database) throws {
        try database.delete("tutorials")
    }
}

// MARK: Temporary error

extension Tutorial {
    enum Error: ErrorProtocol {
        case databaseParseError(String)
    }
}
