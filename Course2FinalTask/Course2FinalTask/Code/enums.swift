import Foundation

public enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

public enum Result<T> {
    case success(T)
    case fail(Error)
    case badResponse(Int)
}
