//
//  TrakApp.swift
//  Trak
//
//
//

import SwiftUI
import SwiftData

@main
struct TrakApp: App {
    @AppStorage("onboard") private var onboard = false      // has user done load screen
    
    init() {
        if UserDefaults.standard.object(forKey: "notesEnabled") == nil {
            UserDefaults.standard.set(true, forKey: "notesEnabled")
        }                                                                   // makes sure notification settings remain
        NotificationManager.shared.requestAuthorization()                   // asks not permission
    }

    var body: some Scene {
        WindowGroup {
            if onboard {
                Menu()
            } else {                            // controls intro pages vs home page
                NavigationStack {               // makes sure app loads to correct point
                    LoadPage()
                }
            }
        }
        .modelContainer(for: [ToDoTask.self, CompletedTask.self])   // swift data storage container
    }
}
