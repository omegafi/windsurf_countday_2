//
//  windsurf_countday_1App.swift
//  windsurf_countday_1
//
//  Created by Server DOĞAN on 20.11.2024.
//

import SwiftUI
import SwiftData

@main
struct windsurf_countday_1App: App {
    let container: ModelContainer
    @AppStorage("themeMode") private var themeMode: ThemeMode = .system
    
    init() {
        do {
            container = try ModelContainer(for: SpecialDay.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .preferredColorScheme(themeMode == .system ? nil : (themeMode == .dark ? .dark : .light))
        }
        .modelContainer(container)
    }
}

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool
    @Published var requiresAuthentication: Bool
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.requiresAuthentication = true // Will be controlled by AppSettings
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}


// test hacı
