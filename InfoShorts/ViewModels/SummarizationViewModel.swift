//
//import Foundation
//import Combine
//
//struct SummarizationResponse: Decodable {
//    let summary_text: String
//}
//
//struct HFErrorResponse: Decodable {
//    let error: String
//}
//
//class SummarizationViewModel: ObservableObject {
//    @Published var summary: String = ""
//    @Published var isSummarizing: Bool = false
//    @Published var errorMessage: String? = nil
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    func summarize(text: String) {
//        guard !text.isEmpty else {
//            self.summary = "No text available to summarize."
//            return
//        }
//        
//        isSummarizing = true
//        errorMessage = nil
//        
//        guard let url = URL(string: "https://api-inference.huggingface.co/models/facebook/bart-large-cnn") else {
//            self.isSummarizing = false
//            self.errorMessage = "Invalid Summarization API URL."
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let payload = ["inputs": text]
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
//            self.isSummarizing = false
//            self.errorMessage = "Failed to encode request payload."
//            return
//        }
//        request.httpBody = httpBody
//        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { (data, response) -> Data in
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    throw URLError(.badServerResponse)
//                }
//                if httpResponse.statusCode != 200 {
//                    // Attempt to decode error message from Hugging Face
//                    if let apiError = try? JSONDecoder().decode(HFErrorResponse.self, from: data) {
//                        throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.error])
//                    }
//                    throw URLError(.badServerResponse)
//                }
//                return data
//            }
//            .decode(type: [SummarizationResponse].self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isSummarizing = false
//                if case let .failure(error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            } receiveValue: { [weak self] response in
//                self?.summary = response.first?.summary_text ?? "Unable to summarize."
//            }
//            .store(in: &cancellables)
//    }
//}
import Foundation
import Combine

struct SummarizationResponse: Decodable {
    let summary_text: String
}

struct HFErrorResponse: Decodable {
    let error: String
}

class SummarizationViewModel: ObservableObject {
    @Published var summary: String = ""
    @Published var isSummarizing: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Summarizes the provided text.
    /// - Parameters:
    ///   - text: The original article text to summarize.
    ///   - maxLength: The maximum number of characters in the summary.
    func summarize(text: String, maxLength: Int? = nil) {
        guard !text.isEmpty else {
            self.summary = "No text available to summarize."
            return
        }
        
        isSummarizing = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api-inference.huggingface.co/models/facebook/bart-large-cnn") else {
            self.isSummarizing = false
            self.errorMessage = "Invalid Summarization API URL."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var payload: [String: Any] = ["inputs": text]
        if let maxLength = maxLength {
            payload["parameters"] = ["max_length": maxLength]
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            self.isSummarizing = false
            self.errorMessage = "Failed to encode request payload."
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if httpResponse.statusCode != 200 {
                    // Attempt to decode error message from Hugging Face
                    if let apiError = try? JSONDecoder().decode(HFErrorResponse.self, from: data) {
                        throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: apiError.error])
                    }
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [SummarizationResponse].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSummarizing = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.summary = response.first?.summary_text ?? "Unable to summarize."
            }
            .store(in: &cancellables)
    }
}
