//
//  POC_infinite_wordHuntApp.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 04/07/24.
//

import SwiftUI
import SwiftData

@main
struct POC_infinite_wordHuntApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Highscore.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()


    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
