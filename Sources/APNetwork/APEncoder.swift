import Foundation

public enum APEncoder {
    case JSON
    func encode(parameters: APParameters) throws -> Data {
        switch self {
        case .JSON:
            return try JSONSerialization.data(withJSONObject: parameters,
                                              options: .prettyPrinted)
        }
    }
}

public enum APDecoder {
    case JSON
    
    func decode<T: Decodable>(data: Data) throws -> T {
        switch self {
        case .JSON:
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
