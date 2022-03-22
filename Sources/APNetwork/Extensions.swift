import Foundation

extension URLComponents {
    static func urlWithQueryParameters(url: URL,
                                       parameters: APParameters) throws -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { throw APError.requestBuilderFailed }
        
        urlComponents.queryItems = [URLQueryItem]()
        for (k, v) in parameters {
            let queryItem = URLQueryItem(name: k,
                                         value: "\(v)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            urlComponents.queryItems?.append(queryItem)
        }
        
        return urlComponents.url
    }
}

