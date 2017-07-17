import Vapor
import VaporUniversity

final class RequestFailedMiddleware: Middleware {
    let env: Environment
    init(env: Environment) {
        self.env = env
    }

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch RESTDriver.Error.requestFailed(let error) {
            let message: String

            if env == .production {
                message = "Something went wrong, please try again later."
            } else {
                message = "Request Failed: \(error)"
            }

            return try drop.view.make("error", [
                "message": message
                ]).makeResponse()
        }
    }
}
