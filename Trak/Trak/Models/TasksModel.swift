//
//  ListPageModels.swift
//  Trak
//
//
//

import Foundation
import SwiftData

@Model
final class ToDoTask { // data model for tasks
    var id = UUID()
    var title: String
    var details: String
    var creationDate: Date //attributes of task
    var dueDate: Date
    var startedAt: Date?
    var categoryRaw: String
    var category: TaskCategory { // used so that swift data can store string while category is enum
        get { TaskCategory(rawValue: categoryRaw) ?? .miscellaneous }
        set { categoryRaw = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), title: String, details: String, creationDate: Date, dueDate: Date, startedAt: Date? = nil, category: TaskCategory) {
        self.id = id
        self.title = title
        self.details = details
        self.creationDate = creationDate // initializer for new task
        self.dueDate = dueDate
        self.startedAt = startedAt
        self.categoryRaw = category.rawValue
    }
}
