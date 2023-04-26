//
//  ContentView.swift
//  Hoopscore Watch Watch App
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct ContentView: View {
    let manager = SessionManager()
    @State var projects: [HPData] = []
    @State var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            List {
                ForEach($projects, id: \.id) { project in
                    NavigationLink(
                        project.wrappedValue.description,
                        destination: { SessionView(data: project.wrappedValue, manager: manager) })
                }
            }.onAppear(perform: {
                reload()
            })
            if $isLoading.wrappedValue {
                VStack() {
                    ProgressView()
                    Button(action: {
                        reload()
                    }, label: {
                        Text("Reload")
                    })
                }
            }
        }
        .navigationTitle({
            VStack(alignment: .leading) {
                Text("Hoopscore")
            }
        })
    }
    
    func reload() {
        manager.requestProjects(compilation: { projects in
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
