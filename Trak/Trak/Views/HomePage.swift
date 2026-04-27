//
//  HomePage.swift
//  Trak
//
//
//

import SwiftUI
import Charts
import SwiftData

struct HomePage: View {
    @StateObject private var viewModel = HomePageViewModel() // viewmodel assignment
    @Query(sort: \CompletedTask.completionDate)                 // gets tasks from data and sorts by coompletion date
    private var completedTasks: [CompletedTask]
    @AppStorage("savedName") private var savedName = ""         // app stored data
    @AppStorage("notes") private var notes = ""
    var body: some View {
        let chart = viewModel.chartData(from: completedTasks)
        let stats = viewModel.stats(from: completedTasks)
        let pie = viewModel.catData(from: completedTasks)
        ScrollView{
            VStack {
                HStack {
                    Text("Hello \(savedName),").font(.largeTitle).bold()
                    Spacer()
                }.padding(.horizontal)
                HStack {
                    Text("Your recent proactivity flow:")
                    Spacer()
                }.padding(.horizontal)
                VStack {
                    if chart.count < 2 {
                                        Text("Complete 2 tasks to start seeing your flow")
                                    } else {
                                        Chart{
                                            ForEach(chart) {point in
                                                LineMark(
                                                    x: .value("Task", point.index),
                                                    y: .value("Score", point.score * 100)           // chart component
                                                ).interpolationMethod(.monotone)
                                                AreaMark(
                                                    x: .value("Task", point.index),
                                                    y: .value("Score", point.score * 100)
                                                ).interpolationMethod(.monotone).foregroundStyle(.blue.opacity(0.3))
                                                PointMark(
                                                    x: .value("Task", point.index),
                                                    y: .value("Score", point.score * 100)
                                                ).foregroundStyle(.blue).symbolSize(45)
                                            }
                                        }.chartXAxis(.hidden).chartYAxis(.hidden).chartXScale(domain: 1...chart.count).chartYScale(domain: 0...100)
                                    }
                                }.frame(width: 330, height:300).padding().background(Color(.white)).clipShape(RoundedRectangle(cornerRadius: 35))
                HStack {
                    Text("Your task split:")
                    Spacer()
                }.padding(.horizontal)
                VStack {
                    if pie.isEmpty {
                        Text("Complete tasks to start")
                    } else {
                        Chart(pie, id: \.category) { item in
                            SectorMark(
                                angle: .value("Count", item.count),
                                innerRadius: 0.5,                                                       // pie chart component
                                angularInset: 2
                            ).cornerRadius(6).foregroundStyle(by: .value("Category", item.category))
                        }.chartLegend(position: .bottom, alignment: .center)
                    }
                }.frame(width: 330, height:300).padding().background(Color(.white)).clipShape(RoundedRectangle(cornerRadius: 35))
                HStack {
                    Text("Your progress:")
                    Spacer()
                }.padding(.horizontal)
                VStack {
                    ForEach(stats) { stat in
                        HStack {                                    // stats component
                            Text(stat.title)
                            Spacer()
                            Text(stat.value)
                        }
                    }
                }.padding().background(Color(.white)).clipShape(RoundedRectangle(cornerRadius: 35))
                VStack {
                    HStack {
                        Text("Your notes:")
                        Spacer()                                                                    // notes component
                    }.padding(.horizontal)
                    TextEditor(text: $notes).frame(height: 300).padding().background(Color(.white)).clipShape(RoundedRectangle(cornerRadius: 35))
                }
            }
        }.padding().background(Color(.gray.opacity(0.1)))
    }
}

#Preview {
    HomePage()
}
