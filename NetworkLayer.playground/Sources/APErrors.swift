import Foundation

public enum APError: Error {
    case noInternet
    case apiFailure
    case invalidResponse
    case decodingError
    case encodingError
    case requestBuilderFailed
}
