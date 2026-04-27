//
//  CRUDPageViewModel.swift
//  Trak
//
//  Created by James Price on 05/04/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor // for main thread
class CreatePageViewModel: ObservableObject { // view looks for changes
    @Published var title: String = ""
    @Published var details: String = ""
    @Published var dueDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
    @Published var category: TaskCategory = .education
    
    func createTask(in modelContext: ModelContext) -> Bool {
        let task = ToDoTask(title: title, details: details, creationDate: .now, dueDate: dueDate, category: category)
        modelContext.insert(task)
        do {
            try modelContext.save()
            if UserDefaults.standard.bool(forKey: "notesEnabled") { // Creates a task saves to swift data and makes reminder in turned on
                NotificationManager.shared.taskReminders(for: task)
            }
            return true
        } catch {
            print("Error saving: \(error)")
            return false
        }
    }
    
    var validInput: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty // trimms and remooves blank space to check input
    }

    
}
