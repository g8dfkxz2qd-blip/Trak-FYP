//
//  InsightsPageViewModel.swift
//  Trak
//
//  Created by James Price on 15/04/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
class InsightsPageViewModel: ObservableObject {
    struct InsightStats: Identifiable {
        let id = UUID()
        let title: String
        let value: String
    }
    
    let categories: [TaskCategory] = [.education, .work, .social, .personal, .home, .miscellaneous  ]
    
    @Published var selectedCategory: TaskCategory? = .education
    
    func filterCompletedTasks(_ tasks: [CompletedTask]) -> [CompletedTask] {
        guard let selectedCategory else { return tasks } // if all no filter
        return tasks.filter {$0.category == selectedCategory} // keeps tasks matching category
    }
    
    func filterActiveTasks(_ tasks: [ToDoTask]) -> [ToDoTask] {
        guard let selectedCategory else { return tasks } // if all no filter
        return tasks.filter {$0.category == selectedCategory} // keeps tasks matching category
    }
    
    func chartData(from tasks: [CompletedTask]) -> [EffortPoint] {
        let sorted = tasks.sorted { $0.completionDate < $1.completionDate }
        let recent = Array(sorted.suffix(10))
        var points: [EffortPoint] = []                  // sorts by date uses last 10 froom sorted list
        var num = 1                                     // returns an array of values for chart with effortpoint
        for task in recent {
            let point = EffortPoint(index: num, score: task.effortScore)
            points.append(point)
            num += 1
        }
        return points
    }
    
    func stats(from completedTasks: [CompletedTask], activeTasks: [ToDoTask]) -> [InsightStats] {
        let completedWeek = completedThisWeek(from: completedTasks)
        let late = lateCount(from: completedTasks)
        let onTime = onTimeCount(from: completedTasks)
        let still = activeTasks.count
        
        return [
            InsightStats(title: "Tasks completed", value: "\(completedWeek)"),      // calculates stats
            InsightStats(title: "Late", value: "\(late)"),                          // returns values/info
            InsightStats(title: "On time", value: "\(onTime)"),
            InsightStats(title: "Remaining", value: "\(still)")
        ]
    }
    
    private func completedThisWeek(from tasks: [CompletedTask]) -> Int {
        let calendar = Calendar.current
        let now = Date()                                                    // uses date for refernce
        var count = 0                                                       // loops through completed tasks to count
        for task in tasks {                                                 // returns number
            if calendar.isDate(task.completionDate, equalTo: now, toGranularity: .weekOfYear) {
                count += 1
            }
        }
        return count
    }
    
    private func lateCount(from tasks: [CompletedTask]) -> Int {
        tasks.filter{$0.completionDate > $0.dueDate}.count              // counts completed tasks after due date
    }
    
    private func onTimeCount(from tasks: [CompletedTask]) -> Int {
        tasks.filter{$0.completionDate <= $0.dueDate}.count             //counts complete on time tasks due on of before due date
    }
}
