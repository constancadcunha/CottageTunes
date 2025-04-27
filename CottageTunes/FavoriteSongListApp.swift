import SwiftUI

@main
struct FavoriteSongListApp: App {
    // Remove the PersistenceController reference
    @StateObject private var viewModel = MusicViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
