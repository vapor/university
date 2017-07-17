import Vapor
import Fluent
import HTTP
import ValidationProvider

extension Tutorial {
    enum Medium: NodeConvertible {
        case video, article

        init(_ string: String) throws {
            switch string {
            case "video":
                self = .video
            case "article":
                self = .article
            default:
                throw Error.databaseParseError("Medium was an invalid type: \(string).")
            }
        }

        init(node: Node) throws {
            guard let string = node.string else {
                throw Error.databaseParseError("Medium was not a string.")
            }

            self = try .init(string)
        }

        func makeNode(in context: Context?) throws -> Node {
            switch self {
            case .article:
                return "article"
            case .video:
                return "video"
            }
        }

        class Validator: Validation.Validator {
            enum Error: Swift.Error {
                case invalid
            }

            func validate(_ input: String) throws {
                do {
                    _ = try Medium(input)
                } catch {
                    throw Error.invalid
                }
            }

            class Middleware: HTTP.Middleware {
                func respond(to request: Request, chainingTo next: Responder) throws -> Response {
                    do {
                        return try next.respond(to: request)
                    } catch Error.invalid {
                        throw Abort(.badRequest, reason: "Invalid medium. Must be either video or article.")
                    }
                }
            }
        }
    }
}
