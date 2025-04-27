import SwiftUI

@main
struct FavoriteSongListApp: App {
    
    @StateObject private var viewModel = MusicViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
