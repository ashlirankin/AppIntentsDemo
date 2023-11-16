//
//  AddTaskView.swift
//  AppIntentsDemo
//
//  Created by Ashli Rankin on 11/13/23.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var taskText = ""
    @State private var taskDate: Date = .now
    
    var body: some View {
        NavigationView {
            Form  {
                TextField(text: $taskText) {
                    Text("Enter the task you want to complete.")
                }
                
                DatePicker("Date", selection: $taskDate)
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "xmark") {
                        taskDate = .now
                        taskText = ""
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        TaskManager.shared.addTask(TodoTask(id: UUID(), title: taskText, createDate: taskDate))
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}
