import Vapor
import Fluent

public final class Tutorial: Vapor.Model {
    public var id: Value?
    public var name: String
    public var description: String
    public var image: String
    public var url: String

    public init(serialized: [String: Fluent.Value]) {
        id = serialized["id"]
        name = serialized["name"].string ?? ""
        description = serialized["description"].string ?? ""
        image = serialized["image"].string ?? ""
        url = serialized["url"].string ?? ""
    }
}
