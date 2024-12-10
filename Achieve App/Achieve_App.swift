//
//  Achieve_AppApp.swift
//  Achieve App
//
//  Created by Xcoder on 12/5/24.
//

import SwiftUI

@main
struct Achieve_AppApp: App {
    @StateObject var manager = HealthManager() // Initialize HealthManager

    var body: some Scene {
        WindowGroup {
            AchieveTabView()
                .environmentObject(manager) // Provide manager to the entire hierarchy
        }
    }
}
