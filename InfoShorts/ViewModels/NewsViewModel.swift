//
//import Foundation
//import Combine
//
//struct NewsResponse: Codable {
//    let status: String
//    let totalResults: Int
//    let articles: [Article]
//}
//
//struct APIErrorResponse: Codable {
//    let status: String
//    let code: String
//    let message: String
//}
//
//class NewsViewModel: ObservableObject {
//    @Published var articles: [Article] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    func fetchNews(query: String, category: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        var urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=40be50d2982c41f39db3ce71174f3b6a"
//        if !query.isEmpty {
//            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
//            urlString += "&q=\(encodedQuery)"
//        }
//        if category.lowercased() != "all" {
//            urlString += "&category=\(category.lowercased())"
//        }
//        
//        guard let url = URL(string: urlString) else {
//            self.isLoading = false
//            self.errorMessage = "Invalid URL."
//            return
//        }
//        
//        URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { (data, response) -> Data in
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    throw URLError(.badServerResponse)
//                }
//                if httpResponse.statusCode != 200 {
//                    if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
//                        throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.message])
//                    }
//                    throw URLError(.badServerResponse)
//                }
//                return data
//            }
//            .decode(type: NewsResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                if case let .failure(error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            } receiveValue: { [weak self] response in
//                self?.articles = response.articles
//            }
//            .store(in: &cancellables)
//    }
//}
import Foundation
import Combine

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct APIErrorResponse: Codable {
    let status: String
    let code: String
    let message: String
}

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchNews(query: String, category: String) {
        isLoading = true
        errorMessage = nil
        
        var urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=40be50d2982c41f39db3ce71174f3b6a"
        if !query.isEmpty {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            urlString += "&q=\(encodedQuery)"
        }
        if category.lowercased() != "all" {
            urlString += "&category=\(category.lowercased())"
        }
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            self.errorMessage = "Invalid URL."
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if httpResponse.statusCode != 200 {
                    if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.message])
                    }
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.articles = response.articles
            }
            .store(in: &cancellables)
    }
}
