//
//  UpDelPageViewModel.swift
//  Trak
//
//  Created by James Price on 06/04/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
class UpDelPageViewModel: ObservableObject {
    @Published var title: String
    @Published var details: String
    @Published var dueDate: Date
    @Published var category: TaskCategory
    
    let task: ToDoTask
    
    init(task: ToDoTask) {
        self.title = task.title
        self.details = task.details
        self.dueDate = task.dueDate
        self.category = task.category
        self.task = task
    }
    
    func updateTask(in modelContext: ModelContext) -> Bool {
        task.title = title
        task.details = details          // puts values back into swift data
        task.dueDate = dueDate
        task.category = category
        
        do {
            try modelContext.save()
            NotificationManager.shared.removeReminder(for: task)            // deletes reminder
            if UserDefaults.standard.bool(forKey: "notesEnabled") {         // makes sure notes are on
                NotificationManager.shared.taskReminders(for: task)         // if yes set new reminders incase it was changed
            }
            return true
        } catch {
            print("Error saving: \(error)")
            return false
        }
    }
    
    func deleteTask(in modelContext: ModelContext) -> Bool {
        NotificationManager.shared.removeReminder(for: task)        // deletd reminder
        modelContext.delete(task)                                   // deleted task
        
        do {
            try modelContext.save()                                 // saves changes
            return true
        } catch {
            print("Error deleting: \(error)")
            return false
        }
    }
    
    var validInput: Bool {                                                  // input valiidation
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
