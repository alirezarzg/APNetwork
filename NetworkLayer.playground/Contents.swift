import Foundation

func main() {
    let ap = APNetwork(urlSession: URLSession.shared)
    
    let request = APRequestBuilder()
        .set(requestProtocol: .https)
        .set(encoding: .JSON)
        .set(baseUrl: "m.mobile.de")
        .set(path: "/svc/a/313894802")
        .set(method: .get)
        .build()
    
    ap
        .call(request: request, responseType: Mbl.self)
    { res in
        switch res {
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
    }
}
main()

struct Mbl: Codable {
    let images: [Image]
}

struct Image:Codable {
    let uri: String
    let set: String
}
