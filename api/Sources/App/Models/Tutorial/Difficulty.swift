import Vapor
import Fluent

extension Tutorial {
    enum Difficulty: NodeConvertible {
        case easy, intermediate, advanced

        init(node: Node) throws {
            guard let difficulty = node.string else {
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
                throw Error.databaseParseError("Difficulty was an invalid type: \(difficulty).")
            }
        }

        func makeNode(in context: Context?) throws -> Node {
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
