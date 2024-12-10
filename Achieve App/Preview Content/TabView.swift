//
//  TabView.swift
//  Achieve App
//
//  Created by Xcoder on 12/5/24.
//
import SwiftUI

struct AchieveTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State private var selectedTab = "Home"

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home View
            HomeView()
                .tag("Home")
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            // Content View
            ProfileView()
                .tag("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    AchieveTabView()
        .environmentObject(HealthManager()) // Provide a mock HealthManager
}
