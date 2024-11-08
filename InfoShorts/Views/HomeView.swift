import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: NewsViewModel
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    
    @State private var searchText: String = ""
    @State private var categories = ["All", "Technology", "Sports", "Politics", "Health", "Business"]
    @State private var selectedCategory: String = "All"
    
    // State for FAB menu
    @State private var showFABMenu = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    // Search Bar
                    SearchBar(text: $searchText, onSearchButtonClicked: {
                        withAnimation {
                            viewModel.fetchNews(query: searchText, category: selectedCategory)
                        }
                    })
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryButton(category: category, isSelected: selectedCategory == category)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedCategory = category
                                            viewModel.fetchNews(query: searchText, category: selectedCategory)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    
                    // News List
                    if viewModel.isLoading {
                        Spacer()
                        LoadingOverlay()
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else if viewModel.articles.isEmpty {
                        Spacer()
                        Text("No articles found.")
                            .foregroundColor(.secondary)
                        Spacer()
                    } else {
                        List(viewModel.articles) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                NewsRow(article: article)
                                    .padding(.vertical, 5)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // Bookmark Action
                                Button {
                                    bookmarkViewModel.addBookmark(article: article)
                                } label: {
                                    Label("Bookmark", systemImage: "bookmark")
                                }
                                .tint(Color("PrimaryColor"))
                                
                                // Share Action
                                Button {
                                    shareArticle(article)
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                .tint(Color("SecondaryColor"))
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color("BackgroundColor"))
                        .refreshable {
                            viewModel.fetchNews(query: searchText, category: selectedCategory)
                        }
                    }
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            // Background Circle
                            Circle()
                                .fill(Color("PrimaryColor"))
                                .frame(width: 60, height: 60)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                            // Plus Icon
                            Image(systemName: showFABMenu ? "xmark" : "plus")
                                .foregroundColor(.white)
                                .font(.title)
                                .rotationEffect(.degrees(showFABMenu ? 45 : 0))
                                .animation(.spring(), value: showFABMenu)
                        }
                        .onTapGesture {
                            withAnimation {
                                showFABMenu.toggle()
                            }
                        }
                        
                        // FAB Menu
                        if showFABMenu {
                            VStack(spacing: 20) {
                                // Refresh Button
                                Button(action: {
                                    viewModel.fetchNews(query: searchText, category: selectedCategory)
                                    withAnimation {
                                        showFABMenu.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(.white)
                                        Text("Refresh")
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color("PrimaryColor"))
                                    .cornerRadius(10)
                                }
                                
                                // Bookmark All Button
                                Button(action: {
                                    bookmarkAllArticles()
                                    withAnimation {
                                        showFABMenu.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "bookmark")
                                            .foregroundColor(.white)
                                        Text("Bookmark All")
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color("SecondaryColor"))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.trailing, 80)
                            .transition(.scale)
                            .animation(.spring(), value: showFABMenu)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitle("NewsSummarizer", displayMode: .inline)
            .toolbar {
                NavigationLink(destination: BookmarksView()) {
                    Image(systemName: "bookmark")
                        .foregroundColor(Color("PrimaryColor"))
                        .font(.title2)
                }
            }
        }
        .onAppear {
            viewModel.fetchNews(query: "", category: selectedCategory)
        }
    }
    
    // Function to share article
    private func shareArticle(_ article: Article) {
        guard let url = URL(string: article.url) else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        // Find the topmost UIViewController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // Function to bookmark all articles
    private func bookmarkAllArticles() {
        for article in viewModel.articles {
            bookmarkViewModel.addBookmark(article: article)
        }
    }
}
