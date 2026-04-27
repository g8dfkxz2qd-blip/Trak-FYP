//
//  SwiftUIView.swift
//  Trak
//
//  Created by James Price on 06/04/2026.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomePage()
                }
            }
            Tab("Your Tasks", systemImage: "list.bullet") {
                NavigationStack {
                    ListPage()
                }
            }                                                       // tabview menu for naviation using nav stack 
            Tab("Insights", systemImage: "chart.bar.fill") {
                NavigationStack {
                    InsightPage()
                }
            }
            Tab("Settings", systemImage: "gearshape.fill") {
                NavigationStack {
                    SettingsPage()
                }
            }



        }
        
    }
}

#Preview {
    Menu()
}
