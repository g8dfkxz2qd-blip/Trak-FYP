//
//  DataPage.swift
//  Trak
//
//
//

import SwiftUI
import SwiftData
import Charts

struct InsightPage: View {
    @StateObject private var viewModel = InsightsPageViewModel() // assigns viewmodel
    @Query(sort: \CompletedTask.completionDate)                 // data read by completion date
    private var completedTasks: [CompletedTask]
    private var filteredCompletedTasks: [CompletedTask] { // sorts
        viewModel.filterCompletedTasks(completedTasks)
    }
    @Query(sort: \ToDoTask.creationDate)
    private var toDoTask: [ToDoTask]
    private var filteredActiveTasks: [ToDoTask] {
        viewModel.filterActiveTasks(toDoTask)
    }
    @State private var notes: String = ""
    var body: some View {
        let chart = viewModel.chartData(from: filteredCompletedTasks)
        let stats = viewModel.stats(from: filteredCompletedTasks, activeTasks: filteredActiveTasks)
        VStack {
            HStack{
                Text("Insights:").font(.largeTitle).bold()
                Spacer()
                Picker("Category", selection: $viewModel.selectedCategory) { // dropdown menu for filter
                    ForEach(viewModel.categories) { category in
                        Text(category.displayName).tag(category) // show category name matching selected type
                    }
                }.pickerStyle(.menu).frame(width: 150)
            }.padding(.horizontal)
            ScrollView {
                HStack {
                    Text("Your recent productivity flow:")
                    Spacer()
                }.padding(.horizontal)
                VStack {
                    VStack {
                        if filteredCompletedTasks.count < 2 {
                            Text("Complete 2 tasks to see your flow")
                        } else {
                            Chart{
                                ForEach(chart) {point in
                                    LineMark(
                                        x: .value("Task", point.index),
                                        y: .value("Score", point.score * 100)
                                    ).interpolationMethod(.monotone)
                                    AreaMark(
                                        x: .value("Task", point.index),
                                        y: .value("Score", point.score * 100)                               // line graph
                                    ).interpolationMethod(.monotone).foregroundStyle(.blue.opacity(0.3))
                                    PointMark(
                                        x: .value("Task", point.index),
                                        y: .value("Score", point.score * 100)
                                    ).foregroundStyle(.blue).symbolSize(45)
                                }
                            }.chartXAxis(.hidden).chartYAxis(.hidden).chartXScale(domain: 1...chart.count).chartYScale(domain: 0...100)
                        }
                    }.frame(width: 330, height:300).padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 35))
                    HStack {
                        Text("Your progress:")
                        Spacer()
                    }.padding(.horizontal)
                    VStack {
                        ForEach(stats) { stat in        // displayed stats
                            HStack {
                                Text(stat.title)
                                Spacer()
                                Text(stat.value)
                            }
                        }
                    }.padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 35))
                    HStack {
                        Text("Your Notes:")
                        Spacer()                                    // notes component 
                    }.padding(.horizontal)
                    VStack {
                        TextEditor(text: $notes).frame(height: 300).padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 35))
                    }
                }
            }
        }.padding().background(Color(.gray.opacity(0.1)))
    }
}

#Preview {
    InsightPage()
}
