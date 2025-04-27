//
//  FavoriteSongListApp.swift
//  FavoriteSongList
//
//  Created by Constança Cunha on 27/04/2025.
//

import SwiftUI

@main
struct FavoriteSongListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
