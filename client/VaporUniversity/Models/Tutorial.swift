import Vapor
import Fluent

public class RESTDriver: DatabaseDriver {
    public let idKey = "id"
    public let url: String
    public let drop: Droplet

    public init(url: String, drop: Droplet) {
        self.url = url
        self.drop = drop
    }

    public func query<T: Fluent.Model>(_ query: Query<T>) throws -> [[String: Fluent.Value]] {
        switch query.action {
        case .fetch:
            var id: String? = nil

            for filter in query.filters {
                switch filter {
                case .compare(let key, let comp, let val):
                    if key == idKey && comp == .equals {
                        id = val.string ?? ""
                    }
                default:
                    break
                }
            }

            if let id = id {
                return try get("\(url)/\(query.entity)/\(id)")
            } else {
                return try get("\(url)/\(query.entity)")
            }
        default:
            return []
        }
    }

    public func schema(_ schema: Schema) throws {
        // nothing
    }

    private func parseObject(_ object: [String: JSON]) -> [String: Fluent.Value] {
        var parsed: [String: Fluent.Value] = [:] // FIXME: Node

        for (key, value) in object {
            switch value {
            case .string(let string):
                parsed[key] = string
            default:
                break
            }
        }

        return parsed
    }

    private func get(_ address: String) throws -> [[String: Fluent.Value]] {
        drop.log.info(address)
        let response = try drop.client.get(address)

        if let json = response.json {
            switch json {
            case .array(let array):
                let parsed: [[String: FluentValue]] = array.flatMap { json in
                    switch json {
                    case .object(let object):
                        return parseObject(object)
                    default:
                        return nil
                    }
                }

                return parsed
            case .object(let object):
                return [parseObject(object)]
            default:
                drop.log.warning("Response was neither array nor object.")
                return []
            }
        } else {
            drop.log.warning("Response was not JSON.")
            return []
        }
    }
}

public final class VaporUniversityDatabase: Database {
    public enum Error: ErrorProtocol {
        case noConfiguredURL
    }

    public init(drop: Droplet) throws {
        guard let url = drop.config["app", "vapor-university-api"].string else {
            throw Error.noConfiguredURL
        }

        let driver = RESTDriver(url: url, drop: drop)
        super.init(driver: driver)
    }
}

public final class Tutorial: Vapor.Model {
    public var id: Value?
    public var name: String

    public init(serialized: [String: Fluent.Value]) {
        id = serialized["id"]
        name = serialized["name"].string ?? ""
    }
}
