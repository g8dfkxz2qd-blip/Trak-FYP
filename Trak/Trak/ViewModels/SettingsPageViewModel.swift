//
//  SettingsPageViewModel.swift
//  Trak
//
//  Created by James Price on 15/04/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class SettingsPageViewModel: ObservableObject {
    @Published var nickname: String = ""
    
    var cleanedName: String {
        nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var validName: Bool {
        !cleanedName.isEmpty
    }
    
    func loadNickname(from savedName: String) {
        nickname = savedName                                            // validation for inputs
    }
    
    func saveName(to savedName: inout String) {
        savedName = cleanedName
    }
    
    func deleteAll(tasks: [ToDoTask], completedTasks: [CompletedTask], modelContext: ModelContext, savedName: inout String, notes: inout String, onboard: inout Bool) -> Bool {
        for task in tasks {
            NotificationManager.shared.removeReminder(for: task)
            modelContext.delete(task)                   // deletes notification reminders for each task
        }                                               // loops through all active and completed tasks and deletes each
        for task in completedTasks {
            modelContext.delete(task)
        }
        do {
            try modelContext.save()
            savedName = ""
            notes = ""                                          // resets all app stored data
            nickname = ""                                       // one last check for notifications
            NotificationManager.shared.removeAllReminders()
            onboard = false                                     // resets onboarding for intro screens
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func handleNotificationToggle(isOn: Bool) {
        if isOn {
            NotificationManager.shared.requestAuthorization()       // notification request for system
        } else {                                                     
            NotificationManager.shared.removeAllReminders()
        }
    }
}



