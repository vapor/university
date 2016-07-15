import Vapor
import Fluent

public final class Tutorial: Vapor.Model {
    public var id: Value?
    public var name: String
    public var author: String
    public var medium: String
    public var description: String
    public var image: String
    public var url: String
    public var difficulty: String
    public var duration: Int

    public init(serialized: [String: Fluent.Value]) {
        id = serialized["id"]
        name = serialized["name"].string ?? ""
        author = serialized["author"].string ?? "Anonymous"
        medium = serialized["medium"].string ?? ""
        description = serialized["description"].string ?? ""
        image = serialized["image"].string ?? ""
        url = serialized["url"].string ?? ""
        difficulty = serialized["difficulty"].string?.uppercaseFirst() ?? ""
        duration = serialized["duration"].int ?? 0
    }
}

//MARK: Fluent serializations

extension Tutorial {
    public func serialize() -> [String: Fluent.Value?] {
        var serialized: [String: Fluent.Value?] = [
            "id": id,
            "name": name,
            "author": author,
            "description": description,
            "image": image,
            "url": url,
            "difficulty": difficulty,
            "duration": duration,
        ]

        if medium == "video" {
            serialized["playable"] = true
        }

        return serialized
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
