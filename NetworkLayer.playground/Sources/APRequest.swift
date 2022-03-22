import Foundation

public typealias APParameters = [String : Any]

public enum APProtocol: String {
    case http = "http://"
    case https = "https://"
}

public enum APMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class APRequest {
    fileprivate var requestProtocol: APProtocol?
    fileprivate var baseURL: String?
    fileprivate var path: String?
    var method: APMethod?
    var parameters = APParameters()
    var encoder: APEncoder?
    var headers = APParameters()
    
    public init() {}
    
    fileprivate func validateRequest() throws {
        guard let method = method else { throw APError.requestBuilderFailed }
        if method != .get && encoder == nil { throw APError.requestBuilderFailed }
    }
    
    func setDefaults(defaultRequestProtocol: APProtocol,
                     defaultBaseURL: String?,
                     defaultEncoder: APEncoder) {
        requestProtocol = requestProtocol ?? defaultRequestProtocol
        baseURL = baseURL ?? defaultBaseURL
        encoder = encoder ?? defaultEncoder
    }
    
    func buildURL() throws -> URL {
        try validateRequest()
        guard let requestProtocol = requestProtocol else { throw APError.requestBuilderFailed }
        guard let baseUrl = baseURL else { throw APError.requestBuilderFailed }
        guard let path = path else { throw APError.requestBuilderFailed }
        
        let urlString = requestProtocol.rawValue + baseUrl + path
        
        guard let url = URL(string: urlString) else { throw APError.requestBuilderFailed }
        
        return url
    }
}

public class APRequestBuilder {
    
    private let request = APRequest()
    
    public init() {}
    
    @discardableResult
    public func set(requestProtocol: APProtocol) -> Self {
        self.request.requestProtocol = requestProtocol
        return self
    }
    
    @discardableResult
    public func set(baseUrl: String) -> Self {
        self.request.baseURL = baseUrl
        return self
    }
    
    @discardableResult
    public func set(path: String) -> Self {
        self.request.path = path
        return self
    }
    
    @discardableResult
    public func set(method: APMethod) -> Self {
        self.request.method = method
        return self
    }
    
    @discardableResult
    public func set(params parameters: APParameters) -> Self {
        self.request.parameters = parameters
        return self
    }
    
    @discardableResult
    public func add(params key: String, value: Any) -> Self {
        self.request.parameters[key] = value
        return self
    }
    
    @discardableResult
    public func set(encoding: APEncoder) -> Self {
        self.request.encoder = encoding
        return self
    }
    
    @discardableResult
    public func set(headers: APParameters) -> Self {
        self.request.headers = headers
        return self
    }
    
    @discardableResult
    public func add(headers key: String, value: Any) -> Self {
        self.request.headers[key] = value
        return self
    }
    
    public func build() -> APRequest {
        return request
    }
}

