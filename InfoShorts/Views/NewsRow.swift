import SwiftUI

struct NewsRow: View {
    let article: Article
    @Namespace private var namespace
    @State private var isVisible: Bool = false
    
    var body: some View {
        NavigationLink(destination: ArticleDetailView(article: article)) {
            VStack(alignment: .leading, spacing: 10) {
                // Article Image
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .matchedGeometryEffect(id: article.id.uuidString, in: namespace)
                    } placeholder: {
                        Color("PlaceholderColor")
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            )
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(15)
                } else {
                    Color("PlaceholderColor")
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                        .cornerRadius(15)
                }

                // Article Details
                VStack(alignment: .leading, spacing: 5) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .lineLimit(2)

                    Text(article.source.name)
                        .font(.subheadline)
                        .foregroundColor(Color("PrimaryColor"))

                    Text(formattedDate(from: article.publishedAt))
                        .font(.caption)
                        .foregroundColor(Color("SecondaryColor"))
                }
                .padding([.horizontal, .bottom], 10)
            }
            .background(Color("CardBackground"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                    isVisible = true
                }
            }
            .transition(.slide)
            .animation(.easeInOut(duration: 0.5), value: article.id)
        }
    }

    // Helper function to format date
    private func formattedDate(from isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}
