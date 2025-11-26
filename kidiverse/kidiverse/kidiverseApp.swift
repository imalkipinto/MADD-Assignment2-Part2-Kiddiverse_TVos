//
//  kidiverseApp.swift
//  kidiverse
//
//  Created by salani nethmika rubasing jayawardhana on 2025-11-26.
//

import SwiftUI

@main
struct kidiverseApp: App {
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                SplashScreen()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
