import Vapor
import Fluent

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
                return "easy"
            case .intermediate:
                return "intermediate"
            case .advanced:
                return "advanced"
            }
        }
    }
}
