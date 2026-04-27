//
//  TaskDoneModel.swift
//  Trak
//
//  Created by James Price on 09/04/2026.
//

import Foundation
import SwiftData

@Model
final class CompletedTask{ // data model for  complete tasks
    var id = UUID()
    var title: String
    var details: String
    var creationDate: Date //attributes of task
    var dueDate: Date
    var startedAt: Date?
    var completionDate: Date
    var categoryRaw: String
    var category: TaskCategory { // used so that swift data can store string while category is enum
        get { TaskCategory(rawValue: categoryRaw) ?? .miscellaneous }
        set { categoryRaw = newValue.rawValue }
    }
    var effortScore : Double
    
    init(id: UUID = UUID(), title: String, details: String, creationDate: Date, dueDate: Date, startedAt: Date? = nil, completionDate: Date, category: TaskCategory, effortScore: Double) {
        self.id = id
        self.title = title
        self.details = details
        self.creationDate = creationDate // initializer for new task
        self.dueDate = dueDate
        self.startedAt = startedAt
        self.completionDate = completionDate
        self.categoryRaw = category.rawValue
        self.effortScore = effortScore
    }
}

