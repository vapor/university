import Vapor
import Fluent

/**
    Converts a Fluent Query into a RESTful request.
*/
public class RESTDriver: Driver, Connection {
    public let idType: IdentifierType = .int
    public var queryLogger: QueryLogger?
    public var keyNamingConvention: KeyNamingConvention = .camelCase

    public func makeConnection(_ type: ConnectionType) throws -> Connection {
        return self
    }

    public var isClosed: Bool {
        return false
    }

    public let idKey = "id"
    public let url: String
    public let drop: Droplet

    public enum Error: Swift.Error {
        case unsupported
        case requestFailed(Swift.Error)
        case notJSON
    }

    public init(url: String, drop: Droplet) {
        self.url = url
        self.drop = drop
    }

    public func query<E: Entity>(_ query: RawOr<Query<E>>) throws -> Node {
        guard case .some(let query) = query else {
            print("Raw not supported")
            return Node.null
        }

        switch query.action {
        case .fetch:
            var id: String? = nil

            var q: [String: NodeRepresentable] = [:]

            for filter in query.filters {
                switch filter {
                case .raw:
                    break
                case .some(let filter):
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
            }

            if let id = id {
                return try get("\(url)/\(E.name)s/\(id)", query: q)
            } else {
                return try get("\(url)/\(E.name)s", query: q)
            }
        default:
            return []
        }
    }

    public func schema(_ schema: Schema) throws {
        // nothing
    }

    private func get(_ address: String, query: [String: NodeRepresentable]) throws -> Node {
        drop.log.info(address)
        do {
            let response = try drop.client.get(address, query: query)

            if let json = response.json {
                return json.makeNode(in: JSON.defaultContext)
            } else {
                drop.log.warning("Response was not JSON.")
                throw Error.requestFailed(Error.notJSON)
            }
        } catch {
            throw Error.requestFailed(error)
        }
    }

    public func raw(_ raw: String, _ values: [Node]) throws -> Node {
        throw Error.unsupported
    }
}
