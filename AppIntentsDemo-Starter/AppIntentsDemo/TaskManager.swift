//
//  TaskManager.swift
//  AppIntentsDemo
//
//  Created by Ashli Rankin on 11/13/23.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class TaskManager: NSObject, ObservableObject {
    
    enum TaskError: LocalizedError {
        case unableToRead
        case unableToWrite
    }
    
    @Published private(set) var tasks: [TodoTask] = []
    @Published private(set) var error: TaskError?
    
    var shouldPresentAlert: Binding<Bool> {
        return Binding {
            return self.error != nil
        } set: { _ in
            self.error = nil
        }
    }
    
    private let persistenceController: PersistenceController = .shared
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = TaskManager()
    
    private override init() {
        super.init()
        
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchTasks()
            }
            .store(in: &cancellables)
    }
    
    func addTask(_ task: TodoTask) {
        do {
            try persistenceController.writeItem(at: .tasksPath, task)
            tasks = try persistenceController.readAllItems(at: .tasksPath)
        } catch {
            self.error = .unableToWrite
        }
    }
    
    @discardableResult
    func fetchTasks() -> [TodoTask] {
        do {
            let tasks: [TodoTask] = try persistenceController.readAllItems(at: .tasksPath)
            self.tasks = tasks
            return tasks
        } catch {
            self.error = .unableToRead
        }
        return []
    }
    
    func markTaskAsComplete(identifier: UUID) {
        do {
            guard var task: TodoTask = try persistenceController.readItem(at: .tasksPath, with: identifier) else {
                self.error = .unableToRead
                return
            }
            task.isComplete = true
            try persistenceController.removeItem(at: .tasksPath, with: task.id, of: TodoTask.self)
            try persistenceController.writeItem(at: .tasksPath, task)
            fetchTasks()
        } catch {
            self.error = .unableToWrite
        }
    }
}
