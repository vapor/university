import Vapor
import Fluent

/**
    Database that uses a RESTful driver pointing to the 
    VaporUniversity API.
*/
public final class VaporUniversityDatabase {
    public let database: Database

    public enum Error: Swift.Error {
        case noConfiguredURL
    }

    public init(drop: Droplet) throws {
        guard let url = drop.config["app", "vapor-university-api"]?.string else {
            throw Error.noConfiguredURL
        }

        let driver = RESTDriver(url: url, drop: drop)
        self.database = Database(driver)
    }
}
