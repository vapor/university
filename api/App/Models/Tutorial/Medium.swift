import Vapor
import Fluent

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
