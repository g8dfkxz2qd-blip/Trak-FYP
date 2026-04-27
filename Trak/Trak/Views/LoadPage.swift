//
//  LoadPage.swift
//  Trak
//
//
//

import SwiftUI

struct LoadPage: View {
    @StateObject private var viewModel = LoadPageViewModel()        // ties to vm
    @AppStorage("savedName") private var savedName = ""         // stored app data
    @State private var AboutPage = false
    
    var body: some View {
        VStack{
            Text("Welcome to Trak").font(.largeTitle).bold().padding()
            Text("Enter a nickname to begin:")
            TextField("Enter here", text: $viewModel.nickname).textFieldStyle(.roundedBorder).padding(.horizontal).frame(width: 225).multilineTextAlignment(.center)
            Button("Continue"){
                savedName = viewModel.cleanedName
                AboutPage = true
            }.disabled(!viewModel.valid).buttonStyle(.borderedProminent).padding()
        }.navigationDestination(isPresented: $AboutPage) {                              // UI to takes inputs valdates and tthen moves to next
            AboutTheAppPage()                                                           // page
        }
    }
}

#Preview {
    LoadPage()
}
