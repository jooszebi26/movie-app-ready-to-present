//
//  movie_app_live_ready_to_presentApp.swift
//  movie-app-live-ready-to-present
//
//  Created by Szebasztian Joo on 2025. 07. 03..
//

import SwiftUI

@main
struct movie_app_live_ready_to_presentApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var selectedTab: TabType = TabType.genre
    
    var body: some Scene {
        WindowGroup {
            MainTabView(selectedTab: $selectedTab)
        }
    }
}
