//
//  CRUDPage.swift
//  Trak
//
//
//

import SwiftUI
import SwiftData

struct CreatePage: View {
    @Environment(\.modelContext) private var modelContext   // access to data
    @Environment(\.dismiss) private var dismiss             // allows page controls
    @StateObject private var viewModel = CreatePageViewModel()    // ties to view model
    var body: some View {
        Form {
            Section("Task") {
                TextField("Title", text: $viewModel.title)                          // input fields
                TextField("Details", text: $viewModel.details, axis:.vertical)
            }
            Section("Due Date") {
                DatePicker("Due Date", selection: $viewModel.dueDate)           // date input field
            }
            Section("Category") {
                Picker("Category", selection: $viewModel.category) {
                    ForEach(TaskCategory.allCases, id: \.self) {            //dropdown category selector showing all enum options
                        Text($0.displayName).tag($0)
                    }
                }
            }
            Section {
                HStack {
                    Spacer()
                    Button("Create") {
                        if viewModel.createTask(in: modelContext) {         // buttons 
                            dismiss()
                        }
                    }.disabled(!viewModel.validInput)
                    Spacer()
                }
            }
        }.navigationTitle("Create Task").toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    CreatePage()
}
