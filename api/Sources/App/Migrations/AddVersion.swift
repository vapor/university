import FluentProvider

final class AddVersion: Preparation {
    static func prepare(_ database: Database) throws {
        try database.modify(Tutorial.self) { builder in
            builder.string("version")
        }

        try database.raw("UPDATE tutorials SET version = 1.0")
    }

    static func revert(_ database: Database) throws {
        try database.modify(Tutorial.self) { builder in
            builder.delete("version")
        }
    }
}
