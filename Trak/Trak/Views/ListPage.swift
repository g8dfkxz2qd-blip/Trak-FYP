//
//  ListPage.swift
//  Trak
//
//
//

import SwiftUI
import SwiftData

struct ListPage: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ListPageViewModel() // view model for view
    @Query(sort: \ToDoTask.creationDate) // gets tasks from swift data
    private var tasks: [ToDoTask]
    private var filteredTasks: [ToDoTask] { // tasks filtered by selected category
        viewModel.filterTasks(tasks)
    }
    @State private var tasksInfo: Set<UUID> = []
    var body: some View {
        VStack {
            HStack {
                Text("To Do:")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Picker("category", selection: $viewModel.selectedCategory) { // dropdown menu for filter
                    Text("All").tag(TaskCategory?.none) // selected category to nill labelled all
                    ForEach(viewModel.categories) { category in
                        Text(category.displayName).tag(category) // show category name matching selected type
                    }
                }.pickerStyle(.menu).frame(width: 150)
                NavigationLink { // button for navigation
                    CreatePage()
                } label: {
                    Image(systemName: "plus.circle").font(.title)
                }
            }.padding(.horizontal)
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(filteredTasks) { task in
                        VStack{
                            HStack {
                                Button {
                                    if tasksInfo.contains(task.id) {
                                        tasksInfo.remove(task.id)
                                    } else {
                                        tasksInfo.insert(task.id)
                                    }
                                } label: {
                                    Image(systemName: "chevron.right").rotationEffect(.degrees(tasksInfo.contains(task.id) ? 90 : 0)).padding(.horizontal)
                                }
                                Text(task.title)
                                Spacer()                                                                            // displays tasks with
                                Text(task.dueDate, format: .dateTime.day().month(.twoDigits).year(.twoDigits))         // with data UI functions
                                Button {                                                                            // and links to relevant
                                    _ = viewModel.completedTasks(task, in: modelContext)                               // pages with nav link
                                } label: {
                                    Image(systemName: "checkmark.circle").font(.title)
                                }
                                NavigationLink {
                                    UpDelPage(task: task)
                                } label: {
                                    Image(systemName: "gearshape").font(.title)
                                }
                            }
                            if tasksInfo.contains(task.id) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Category: \(task.category.displayName)").font(.caption)
                                    Spacer()
                                    if task.details.isEmpty {                                           // controls data foro expnadable 
                                        Text("Details: No details to show.").font(.caption)
                                    } else {
                                        Text("Details: \(task.details)").font(.caption)
                                    }
                            
                                    
                                    
                                }.padding(.vertical).frame(width: 230, alignment: .leading)
                            }
                        }.padding().background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 35))
                    }
                }
            }
        }.padding().background(Color.gray.opacity(0.1))
    }
}

#Preview {
    ListPage()
}


