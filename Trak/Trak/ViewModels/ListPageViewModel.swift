//
//  ListPageViewModel.swift
//  Trak
//
//
//

import Foundation
import SwiftData
import Combine

@MainActor // for main thread
class ListPageViewModel: ObservableObject { // view looks for changes
    
    let categories: [TaskCategory] = TaskCategory.allCases // preset categories for dropdown

    @Published var selectedCategory: TaskCategory? = nil // for crrently selected nil means show all
    
    func filterTasks(_ tasks: [ToDoTask]) -> [ToDoTask] {
        guard let selected = selectedCategory else { return tasks } // if all no filter
        return tasks.filter {$0.category == selected} // keeps tasks matching category
    }
    func completedTasks(_ task: ToDoTask, in modelContext: ModelContext) -> Bool {
        let totalTime = task.dueDate.timeIntervalSince(task.creationDate)   // calculates total time for task
        let score = totalTime > 0 ? max(0, min(task.dueDate.timeIntervalSince(Date()) / totalTime, 1)) : 0  // calculates time left at point of completion, min max locks score to between 1 and 0
        let completedTask = CompletedTask(title: task.title, details: task.details, creationDate: task.creationDate, dueDate: task.dueDate, startedAt: task.startedAt, completionDate: .now, category: task.category, effortScore: score)
        
        NotificationManager.shared.removeReminder(for: task)            // creates task productiviity effort score
                                                                        // ceates new completed task using task data
        modelContext.insert(completedTask)                              // delets notfication
        modelContext.delete(task)                                       // inserts complete and deletes old active task
                                                                        // saves
        do {
            try modelContext.save()
            return true
        } catch {
            print ("Error completing task: \(error)")
            return false
        }
    }
}
