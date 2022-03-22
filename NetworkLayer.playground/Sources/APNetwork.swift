import Foundation

public class APNetwork {
    private var urlSession : URLSession
    private var defaultBaseURL: String?
    private var defaultRequestProtocol: APProtocol = APProtocol.https
    private var defaultEncoder: APEncoder = APEncoder.JSON
    private var defaultDecoder: APDecoder = APDecoder.JSON
    
    public init(_ urlSession : URLSession) {
        self.urlSession = urlSession
    }
    
    public convenience init(urlSession : URLSession,
                            defaultBaseURL: String? = nil,
                            defaultRequestProtocol: APProtocol = APProtocol.https,
                            defaultEncoder: APEncoder = APEncoder.JSON,
                            defaultDecoder: APDecoder = APDecoder.JSON) {
        self.init(urlSession)
        
        self.urlSession = urlSession
        self.defaultBaseURL = defaultBaseURL
        self.defaultRequestProtocol = defaultRequestProtocol
        self.defaultEncoder = defaultEncoder
        self.defaultDecoder = defaultDecoder
    }
    
    
    public func call<T: Decodable>(request: APRequest,
                                   responseType: T.Type,
                                   onCompletion: @escaping (Result<T,APError>) -> Void) {
        
        do {
            let urlRequest = try createURLRequest(request : request)
            _call(urlSession: urlSession, urlRequest: urlRequest, onCompletion: onCompletion)
        } catch {
            let networkError = error as? APError ?? APError.apiFailure
            onCompletion(.failure(networkError))
        }
    }
    
    private func createURLRequest(request: APRequest) throws -> URLRequest {
        request.setDefaults(defaultRequestProtocol: defaultRequestProtocol,
                            defaultBaseURL: defaultBaseURL,
                            defaultEncoder: defaultEncoder)
        let url = try request.buildURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method!.rawValue
        switch  request.method {
        case .get:
            urlRequest.url = try URLComponents.urlWithQueryParameters(url: url, parameters: request.parameters)
        default:
            urlRequest.httpBody = try  request.encoder!.encode(parameters:  request.parameters)
        }
        
        request.headers.forEach {
            urlRequest.addValue("\($0.value)", forHTTPHeaderField: $0.key)
        }
        return urlRequest
    }
    
    private func _call<T:Decodable>(urlSession:URLSession , urlRequest:URLRequest,onCompletion: @escaping (Result<T,APError>) -> Void){
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                onCompletion(.failure(APError.apiFailure))
                return
            }
            do {
                let resource: T = try APDecoder.JSON.decode(data: data)
                onCompletion(.success(resource))
            } catch {
                onCompletion(.failure(APError.noInternet))
            }
        }.resume()
    }
}
