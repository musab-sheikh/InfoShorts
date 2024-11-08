import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    @State private var showingDeleteAlert = false
    @State private var bookmarkToDelete: Bookmark?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if bookmarkViewModel.bookmarks.isEmpty {
                        Spacer()
                        Text("No bookmarks yet.")
                            .foregroundColor(.secondary)
                            .font(.title2)
                            .animation(nil)
                        Spacer()
                    } else {
                        List {
                            ForEach(bookmarkViewModel.bookmarks) { bookmark in
                                NavigationLink(destination: ArticleDetailView(article: bookmark.article)) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(bookmark.article.title)
                                            .font(.headline)
                                            .foregroundColor(Color("TextColor"))
                                            .lineLimit(2)
                                        
                                        Text(bookmark.article.source.name)
                                            .font(.subheadline)
                                            .foregroundColor(Color("PrimaryColor"))
                                    }
                                    .padding(.vertical, 5)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        bookmarkToDelete = bookmark
                                        showingDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color("BackgroundColor"))
                    }
                }
            }
            .navigationBarTitle("Bookmarks", displayMode: .inline)
            .toolbar {
                EditButton()
                    .foregroundColor(Color("PrimaryColor"))
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Bookmark"),
                    message: Text("Are you sure you want to delete this bookmark?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let bookmark = bookmarkToDelete {
                            bookmarkViewModel.removeBookmark(bookmark)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
