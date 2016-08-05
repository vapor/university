import Vapor
import Fluent

/**
    Converts a Fluent Query into a RESTful request.
*/
public class RESTDriver: Driver {
    public let idKey = "id"
    public let url: String
    public let drop: Droplet

    public enum Error: Swift.Error {
        case unsupported
    }

    public init(url: String, drop: Droplet) {
        self.url = url
        self.drop = drop
    }

    public func query<T: Entity>(_ query: Query<T>) throws -> Node {
        switch query.action {
        case .fetch:
            var id: String? = nil

            var q: [String: CustomStringConvertible] = [:]

            for filter in query.filters {
                switch filter.method {
                case .compare(let key, let comp, let val):
                    if comp == .equals {
                        if key == idKey {
                            id = val.string
                        } else {
                            q[key] = val.string ?? ""
                        }
                    }
                default:
                    break
                }
            }

            if let id = id {
                return try get("\(url)/\(query.entity)/\(id)", query: q)
            } else {
                return try get("\(url)/\(query.entity)", query: q)
            }
        default:
            return []
        }
    }

    public func schema(_ schema: Schema) throws {
        // nothing
    }

    private func get(_ address: String, query: [String: CustomStringConvertible]) throws -> Node {
        drop.log.info(address)
        let response = try drop.client.get(address, query: query)

        if let json = response.json {
            return json.makeNode()
        } else {
            drop.log.warning("Response was not JSON.")
            return []
        }
    }

    public func raw(_ raw: String, _ values: [Node]) throws -> Node {
        throw Error.unsupported
    }
}
