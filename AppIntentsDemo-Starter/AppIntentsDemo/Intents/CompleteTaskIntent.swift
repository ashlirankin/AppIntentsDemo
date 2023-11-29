//
//  CompleteTaskIntent.swift
//  AppIntentsDemo
//
//  Created by Ashli Rankin on 11/13/23.
//

import Foundation
import AppIntents

struct CompleteTaskIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Complete Task"
    
    @Parameter(title: "Date")
    var date: Date
    
    @Parameter(title: "Task")
    var task: TodoTask
    
    private let taskManager = TaskManager.shared
    
    @MainActor
    func perform() async throws -> some IntentResult {
        taskManager.markTaskAsComplete(task: task)
        return .result()
    }
}
