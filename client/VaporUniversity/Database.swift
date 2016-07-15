import Vapor
import Fluent

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
