//
//  TodoListView.swift
//  AppIntentsDemo
//
//  Created by Ashli Rankin on 11/13/23.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject private var taskManager: TaskManager = .shared
    @State private var shouldShowAddView = false
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Group {
                List(taskManager.tasks, id: \.id) { task in
                    Button {
                        taskManager.markTaskAsComplete(task: task)
                    } label: {
                        HStack {
                            Image(systemName: task.isComplete ? "multiply.square" : "square")
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.isComplete)
                                Text(task.createDate, formatter: Self.taskDateFormat)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .strikethrough(task.isComplete)
                            }
                        }
                    }
                }
            }
            .navigationTitle("TO-DOs")
            .toolbar {
                Button("", systemImage: "plus") {
                    shouldShowAddView = true
                }
            }
        }
        .sheet(isPresented: $shouldShowAddView) {
            AddTaskView()
        }
    }
}

#Preview {
    TodoListView()
}
