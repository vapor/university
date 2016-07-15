import Vapor

typealias Value = FluentValue

final class Tutorial: Model {
    enum Error: ErrorProtocol {
        case databaseParseError(String)
    }

    var id: Value?
    var name: String
    var medium: Medium
    var url: String
    var description: String
    var duration: Int
    var difficulty: Difficulty

    init(serialized: [String: Value]) { // FIXME: init(Value)
        id = serialized["id"]
        name = serialized["name"].string ?? ""
        medium = try! Medium(serialized["medium"]!)
        url = serialized["url"].string ?? ""
        description = serialized["description"].string ?? ""
        duration = serialized["duration"].int ?? 0
        difficulty = try! Difficulty(serialized["difficulty"]!)
    }

    func serialize() -> [String: Value?] { // FIXME: ValueRepresentable
        return [
            "id": id,
            "name": name,
            "medium": try! medium.value(), // FIXME: not throwing
            "url": url,
            "description": description,
            "duration": duration,
            "difficulty": try! difficulty.value()
        ]
    }

    static func prepare(database: Database) throws {
        try database.create("tutorials") { tutorials in
            tutorials.id()
            tutorials.string("name")
            tutorials.string("medium") // FIXME: enum support
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

extension Tutorial {
    enum Medium {
        case video, article

        init(_ string: String) throws {
            switch string {
            case "video":
                self = .video
            case "article":
                self = .article
            default:
                throw Error.databaseParseError("Medium was an invalid type.")
            }
        }

        init(_ value: Value) throws {
            guard let string = value.string else {
                throw Error.databaseParseError("Medium was not a string.")
            }

            self = try .init(string)
        }

        func value() throws -> Value {
            switch self {
            case .article:
                return "article"
            case .video:
                return "video"
            }
        }

        class Validator: ValidationSuite {
            enum Error: ErrorProtocol {
                case invalid
            }

            static func validate(input: String) throws {
                do {
                    _ = try Medium(input)
                } catch {
                    throw Error.invalid
                }
            }

            class Middleware: Vapor.Middleware {
                func respond(to request: Request, chainingTo next: Responder) throws -> Response {
                    do {
                        return try next.respond(to: request)
                    } catch Error.invalid {
                        throw Abort.custom(status: .badRequest, message: "Invalid medium. Must be either video or article.")
                    }
                }
            }
        }
        }
}

extension Tutorial {
    enum Difficulty {
        case easy, intermediate, advanced

        init(_ value: Value) throws {
            guard let difficulty = value.string else {
                throw Error.databaseParseError("Difficulty was not a string.")
            }

            switch difficulty {
            case "easy":
                self = .easy
            case "intermediate":
                self = .intermediate
            case "advanced":
                self = .advanced
            default:
                throw Error.databaseParseError("Medium was an invalid type.")
            }
        }

        func value() throws -> Value {
            switch self {
            case .easy:
                return "article"
            case .intermediate:
                return "intermediate"
            case .advanced:
                return "advanced"
            }
        }
    }
}
