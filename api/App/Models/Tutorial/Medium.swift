import Vapor
import Fluent
import HTTP

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
                throw Error.databaseParseError("Medium was an invalid type.")
            }
        }

        init(node: Node, in context: Context) throws {
            guard let string = node.string else {
                throw Error.databaseParseError("Medium was not a string.")
            }

            self = try .init(string)
        }

        func makeNode() throws -> Node {
            switch self {
            case .article:
                return "article"
            case .video:
                return "video"
            }
        }

        class Validator: ValidationSuite {
            enum Error: Swift.Error {
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
