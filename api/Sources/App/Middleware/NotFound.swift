import Vapor
import HTTP

class NotFound: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch let error as AbortError where error.status == .notFound {
            throw Abort(.notFound, reason: "Resource not found.")
        }
    }
}
