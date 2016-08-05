import Vapor
import HTTP

class NotFound: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch Abort.notFound {
            throw Abort.custom(status: .notFound, message: "Resource not found.")
        }
    }
}
