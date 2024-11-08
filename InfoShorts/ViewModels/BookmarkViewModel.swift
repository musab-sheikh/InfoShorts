import Foundation
import Combine

class BookmarkViewModel: ObservableObject {
    @Published var bookmarks: [Bookmark] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadBookmarks()
        
        // Observe changes and save automatically
        $bookmarks
            .sink { [weak self] _ in
                self?.saveBookmarks()
            }
            .store(in: &cancellables)
    }
    
    func addBookmark(article: Article) {
        let bookmark = Bookmark(id: UUID(), article: article)
        if !bookmarks.contains(where: { $0.article.url == article.url }) {
            bookmarks.append(bookmark)
        }
    }
    
    func removeBookmark(at offsets: IndexSet) {
        bookmarks.remove(atOffsets: offsets)
    }
    
    func removeBookmark(_ bookmark: Bookmark) {
        if let index = bookmarks.firstIndex(where: { $0.id == bookmark.id }) {
            bookmarks.remove(at: index)
        }
    }
    
    private func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encoded, forKey: "bookmarks")
        }
    }
    
    private func loadBookmarks() {
        if let data = UserDefaults.standard.data(forKey: "bookmarks"),
           let decoded = try? JSONDecoder().decode([Bookmark].self, from: data) {
            bookmarks = decoded
        }
    }
}
