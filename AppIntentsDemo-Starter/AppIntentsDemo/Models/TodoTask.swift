//
//  TodoTask.swift
//  AppIntentsDemo
//
//  Created by Ashli Rankin on 11/13/23.
//

import Foundation
import AppIntents

struct TodoTask: Codable, Identifiable  {
    
    let id: UUID
    
    /// The title of the task.
    let title: String
    
    /// The date the task will be excepted.
    let executionDate: Date
    
    /// Indicates if the task has been completed
    var isComplete: Bool = false
}

extension TodoTask: AppEntity {
    
    struct TaskQuery: EntityQuery {
        
        @IntentParameterDependency<CompleteTaskIntent>(
            \.$date
        )
        var markTaskIntent
        
        private let taskManager: TaskManager = TaskManager.shared
        
        func entities(for identifiers: [Entity.ID]) async throws -> [TodoTask] {
            return try await suggestedEntities().filter { task in
                return identifiers.contains(task.id)
            }
        }
        
        func suggestedEntities() async throws -> [TodoTask] {
            guard let selectedDate = markTaskIntent?.date else {
                return []
            }
            
            let calendar = Calendar.autoupdatingCurrent
            
            let startDate: Date = calendar.startOfDay(for: selectedDate)
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
           
            let foundTasks: [TodoTask] = await taskManager.fetchTasks()
            let filteredTasks: [TodoTask] = foundTasks.filter { task in
                task.executionDate >= startDate &&  task.executionDate < endDate && !task.isComplete
            }
            return filteredTasks
        }
    }
    
    var displayRepresentation: DisplayRepresentation {
        return .init(stringLiteral: "\(title)")
    }
    
    static var defaultQuery: TaskQuery = TaskQuery()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Task")
}
