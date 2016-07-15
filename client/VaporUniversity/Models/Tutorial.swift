import Vapor
import Fluent

public final class Tutorial: Vapor.Model {
    public var id: Value?
    public var name: String
    public var medium: String
    public var description: String
    public var image: String
    public var url: String

    public init(serialized: [String: Fluent.Value]) {
        id = serialized["id"]
        name = serialized["name"].string ?? ""
        medium = serialized["medium"].string ?? ""
        description = serialized["description"].string ?? ""
        image = serialized["image"].string ?? ""
        url = serialized["url"].string ?? ""
    }

    public func serialize() -> [String: Fluent.Value?] {
        var serialized: [String: Fluent.Value?] = [
            "id": id,
            "name": name,
            "description": description,
            "image": image,
            "url": url,
        ]

        if medium == "video" {
            serialized["playable"] = true
        }

        return serialized
    }
}
