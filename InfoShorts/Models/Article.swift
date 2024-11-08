import Foundation

struct Article: Identifiable, Codable, Equatable {
    let id: UUID = UUID() // Unique identifier for SwiftUI
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    // Exclude 'id' from coding keys since it's generated locally
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

struct Source: Codable, Equatable {
    let id: String?
    let name: String
}
