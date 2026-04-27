//
//  AboutTheAppPage.swift
//  Trak
//
//  Created by James Price on 10/04/2026.
//

// displays UI for page

import SwiftUI

struct AboutTheAppPage: View {
    @AppStorage("onboard") private var onboard = false
    
    var body: some View {
        VStack{
            Text("About the app.").font(.largeTitle).bold().padding()
            VStack{
                Text("Trak is designed as a tool for organisation and productivity management. It's goal is to get people back on track and help people stay balanced. ").padding().multilineTextAlignment(.center)
                Text("The app has been designed to be as intuitive as possible the best way to learn is to explore and try it out. To Use full functionality of the app add some tasks.").padding().multilineTextAlignment(.center)
                Text("While our goal is to be as helpful as possible we are not a replacement for professional support. If you need any support beyond our app please contact a medical professional.").padding().multilineTextAlignment(.center)
                Spacer()
                Text("We hope you enjoy the app.").padding().multilineTextAlignment(.center)
                Button("Get Started") {
                    onboard = true
                }.buttonStyle(.borderedProminent)
            }.padding(30)
        }
    }
}

#Preview {
    AboutTheAppPage()
}
