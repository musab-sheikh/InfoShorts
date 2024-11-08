import Foundation

struct Bookmark: Identifiable, Codable, Equatable {
    let id: UUID
    let article: Article
}
