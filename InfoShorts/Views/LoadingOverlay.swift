import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryColor")))
                    .scaleEffect(1.5)
                Text("Fetching the latest news for you!")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color("CardBackground"))
            .cornerRadius(15)
            .shadow(radius: 10)
            .transition(.opacity)
        }
    }
}
