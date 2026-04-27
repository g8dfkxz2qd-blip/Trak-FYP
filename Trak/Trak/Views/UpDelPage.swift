//
//  File.swift
//  Trak
//
//  Created by James Price on 06/04/2026.
//

import SwiftUI
import SwiftData

struct UpDelPage: View {
    @Environment(\.modelContext) private var modelContext       // gives data
    @Environment(\.dismiss) private var dismiss                 // allows page contol
    @StateObject private var viewModel: UpDelPageViewModel
    
    init(task: ToDoTask) {
        _viewModel = StateObject(wrappedValue: UpDelPageViewModel(task: task))
    }
    
    var body: some View {
        Form {
            Section("Task") {
                TextField("Title", text: $viewModel.title)
                TextField("Details", text: $viewModel.details, axis:.vertical)      //inout fields
            }
            Section("Due Date") {
                DatePicker("Due Date", selection: $viewModel.dueDate)
            }
            Section("Category") {
                Picker("Category", selection: $viewModel.category) {
                    ForEach(TaskCategory.allCases, id: \.self) {            // dropdown
                        Text($0.displayName).tag($0)
                    }
                }
            }
            Section {
                Button {
                    if viewModel.deleteTask(in: modelContext) {
                        dismiss()
                    }
                }label: {
                    HStack{
                        Spacer()
                        Text("Delete")
                        Spacer()
                    }
                }.foregroundStyle(.red)
                Button {
                    if viewModel.updateTask(in: modelContext) {             // buttons
                        dismiss()
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text("Update")
                        Spacer()
                    }
                }.disabled(!viewModel.validInput)
            }
        }.navigationTitle("Update Task").toolbar(.hidden, for: .tabBar)
        
    }
}



