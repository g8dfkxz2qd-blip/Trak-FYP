//
//  HomePageViewModel.swift
//  Trak
//
//  Created by James Price on 09/04/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
class HomePageViewModel: ObservableObject {
    
    struct HomeStats: Identifiable {
        let id = UUID()
        let title: String
        let value: String
    }
    
    func catData(from tasks: [CompletedTask]) -> [(category: String, count: Int)] {
        var counts: [String: Int] = [:]
        for task in tasks {
            counts[task.category.displayName, default: 0] += 1 // loops every task uses category name as dictionary key
        }                                                       // count number and convert to array of tuples for chart
        return counts.map {(category: $0.key, count: $0.value)}
    }
    
    func chartData(from tasks: [CompletedTask]) -> [EffortPoint] {
        let sorted = tasks.sorted { $0.completionDate < $1.completionDate }
        let recent = Array(sorted.suffix(10))       // sorts tasks oldest to newest takes last 10 from list
        var points: [EffortPoint] = []              // numbers thhe task and uses effort score as value to return an array
        var num = 1
        for task in recent {
            let point = EffortPoint(index: num, score: task.effortScore)
            points.append(point)
            num += 1
        }
        return points
    }
    
    func stats(from tasks: [CompletedTask]) -> [HomeStats] {
        let completedNum = tasks.count
        let weekCount = thisWeek(from: tasks)               // calculate and retirns needed stats
        let topCat = weekTop(from: tasks)
        return [
            HomeStats(title: "Tasks Completed", value: "\(completedNum)"),
            HomeStats(title: "Tasks This Week", value: "\(weekCount)"),
            HomeStats(title: "Top Category", value: "\(topCat)")
        ]
    }
    
    func thisWeek(from tasks: [CompletedTask]) -> Int {
        let calendar = Calendar.current
        let now = Date()                        // counts by looping trhoug completed tasks
        var count = 0                           // and checking dates then returns count
        for task in tasks {
            if calendar.isDate(task.completionDate, equalTo: now, toGranularity: .weekOfYear) {
                count += 1
            }
        }
        return count
    }
    
    func weekTop(from tasks: [CompletedTask]) -> String {
        if tasks.isEmpty { return "Nothing yet" }
        var counts: [String: Int] = [:]
        for task in tasks {
            let catName = task.category.displayName
            if counts[catName] == nil {
                counts[catName] = 1
            } else {
                counts[catName]! += 1
            }
        }
        var max = 0
        var topCat = ""                         // if no completted return nothing yet
        var isTie = false                       // counts times category appears retirns number
        for (catName, count) in counts {        // if even categories then show "even split"
            if count > max {
                max = count
                topCat = catName
                isTie = false
            } else if count == max {
                isTie = true
            }
        }
        if isTie {
            return "Even Split"
        } else {
            return topCat
        }
    }
}
