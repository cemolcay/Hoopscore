//
//  ContentView.swift
//  Hoopscore Watch Watch App
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct ContentView: View {
    @State var projects: [HPData] = []
    @State var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            List {
                // New Session
                NavigationLink(
                    "+ New Session",
                    destination: { SessionRequestView(projectId: nil) })
                // Sessions
                ForEach($projects, id: \.id) { project in
                    NavigationLink(
                        project.wrappedValue.description,
                        destination: { SessionRequestView(projectId: project.id) })
                }
            }.onAppear(perform: {
                _ = SessionManager.shared
                reload()
            }).overlay(content: {
                if $isLoading.wrappedValue {
                    VStack() {
                        ProgressView()
                        Button(action: {
                            reload()
                        }, label: {
                            Text("Reload")
                        })
                    }.background(content: { Color(.black) })
                }
            })
        }.navigationTitle({
            Text("Hoopscore")
        })
    }
    
    func reload() {
        SessionManager.shared.requestProjects(compilation: { projects in
            self.projects = projects
            self.isLoading = false
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
