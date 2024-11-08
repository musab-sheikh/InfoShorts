import SwiftUI

struct MainTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("selectedAccentColor") private var selectedAccentColor: String = "PrimaryColor"
    
    @StateObject var viewModel = NewsViewModel()
    @StateObject var bookmarkViewModel = BookmarkViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            BookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(Color(selectedAccentColor))
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environmentObject(viewModel)
        .environmentObject(bookmarkViewModel)
    }
}
