import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    // Instantiate SummarizationViewModel
    @StateObject private var summarizationViewModel = SummarizationViewModel()
    
    // Access BookmarkViewModel via EnvironmentObject
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel
    
    // State variables for UI control
    @State private var showConciseSummary = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Article Image with Rounded Corners and Shadow
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color("PlaceholderColor")
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            )
                    }
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 250)
                    .clipped()
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                
                // Article Title
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
                    .multilineTextAlignment(.leading)
                
                // Article Description
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                        .multilineTextAlignment(.leading)
                }
                
                // Summary Section with Rounded Background
                VStack(alignment: .leading, spacing: 10) {
                    if summarizationViewModel.isSummarizing {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryColor")))
                            Text("Summarizing...")
                                .font(.body)
                                .foregroundColor(Color("TextColor"))
                        }
                        .transition(.opacity)
                    } else if let error = summarizationViewModel.errorMessage {
                        Text(error)
                            .font(.body)
                            .foregroundColor(.red)
                            .transition(.opacity)
                    } else {
                        Text(summarizationViewModel.summary)
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                            .padding()
                            .background(Color("SecondaryColor").opacity(0.1))
                            .cornerRadius(10)
                            .transition(.slide)
                            .animation(.easeInOut, value: summarizationViewModel.summary)
                    }
                    
                    // Toggle for Concise Summary
                    if !summarizationViewModel.summary.isEmpty {
                        Button(action: {
                            withAnimation {
                                showConciseSummary.toggle()
                                if showConciseSummary {
                                    summarizeConcise()
                                } else {
                                    summarizationViewModel.summarize(text: article.description ?? article.title, maxLength: 500) // Reset to full summary
                                }
                            }
                        }) {
                            Text(showConciseSummary ? "Show Full Summary" : "Show Concise Summary")
                                .font(.subheadline)
                                .foregroundColor(Color("PrimaryColor"))
                                .padding(.top, 5)
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.top, 10)
                
                // Action Buttons with Icon Styling
                HStack(spacing: 30) {
                    Spacer()
                    
                    // Bookmark Button with Animation
                    Button(action: {
                        bookmarkViewModel.addBookmark(article: article)
                        alertMessage = "Article bookmarked!"
                        showAlert = true
                    }) {
                        Image(systemName: bookmarkViewModel.bookmarks.contains(where: { $0.article.url == article.url }) ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .foregroundColor(bookmarkViewModel.bookmarks.contains(where: { $0.article.url == article.url }) ? Color("PrimaryColor") : .gray)
                            .padding()
                            .background(Color("SecondaryColor").opacity(0.1))
                            .clipShape(Circle())
                            .scaleEffect(bookmarkViewModel.bookmarks.contains(where: { $0.article.url == article.url }) ? 1.2 : 1.0)
                            .animation(.spring(), value: bookmarkViewModel.bookmarks)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Success"),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("OK")))
                    }
                    
                    // Share Button with Animation
                    Button(action: {
                        if let url = URL(string: article.url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.title2)
                            .foregroundColor(Color("PrimaryColor"))
                            .padding()
                            .background(Color("SecondaryColor").opacity(0.1))
                            .clipShape(Circle())
                            .rotationEffect(.degrees(showConciseSummary ? 45 : 0))
                            .animation(.easeInOut(duration: 0.3), value: showConciseSummary)
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .onAppear {
            // Automatically fetch the full summary when the view appears
            summarizationViewModel.summarize(text: article.description ?? article.title, maxLength: 500) // Adjust maxLength as needed
        }
    }
    
    // MARK: - Helper Functions
    /// Summarizes the article concisely with a shorter summary.
    private func summarizeConcise() {
        // Assuming 20 lines ~ 300 characters; adjust based on actual content
        summarizationViewModel.summarize(text: article.description ?? article.title, maxLength: 300)
    }
}
