import Foundation

func main() {
    let ap = AP(urlSession: URLSession.shared)
    
    let request = APRequestBuilder()
        .set(requestProtocol: .https)
        .set(encoding: .JSON)
        .set(baseUrl: "animechan.vercel.app")
        .set(path: "/api/available/anime")
        .set(method: .get)
        .build()
    
    ap
        .call(request: request, responseType: [String].self)
    { res in
        print(res)
    }
}
main()

