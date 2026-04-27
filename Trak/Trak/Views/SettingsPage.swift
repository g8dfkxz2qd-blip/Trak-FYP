//
//  SettingsPage.swift
//  Trak
//
//
//

import SwiftUI
import SwiftData

struct SettingsPage: View {
    @Environment(\.modelContext) private var modelContext                   // access to data
    @StateObject private var viewModel = SettingsPageViewModel()            // ties vm
    @Query(sort: \ToDoTask.creationDate) private var tasks: [ToDoTask]                          // reads data by date
    @Query(sort: \CompletedTask.completionDate) private var completedTasks: [CompletedTask]
    @AppStorage("savedName") private var savedName = ""
    @AppStorage("notes") private var notes = ""
    @AppStorage("onboard") private var onboard = false                      // app storage values
    @AppStorage("notesEnabled") private var notesEnabled = true
    var body: some View {
        Form {
            Section("Profile") {
                TextField("Your name", text: $viewModel.nickname)
                HStack{
                    Spacer()                                            // UI for name change
                    Button("Save") {
                        viewModel.saveName(to: &savedName)
                    }.disabled(!viewModel.validName)
                    Spacer()
                }
            }
            Section("Notifications") {
                Toggle("Reminders", isOn: $notesEnabled)
                    .onChange(of: notesEnabled) {                                               // toggle for notifications
                        _, newValue in viewModel.handleNotificationToggle(isOn: newValue)
                    }
            }
            Section("Data Management") {
                Button("Erase all data", role: .destructive) {
                    _ = viewModel.deleteAll(
                        tasks: tasks,
                        completedTasks: completedTasks,
                        modelContext: modelContext,
                        savedName: &savedName,                                      // button for full reset
                        notes: &notes,
                        onboard: &onboard)
                }
            }
        }.onAppear{
            viewModel.loadNickname(from: savedName)
        }
    }
}
