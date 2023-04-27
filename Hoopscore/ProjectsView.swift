//
//  ProjectsView.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct ProjectsView: View {
    @State var selectedProjectId: UUID?
    @ObservedObject var projects = ProjectManager.shared
    
    var body: some View {
        ZStack {
            List {
                // New session
                Button(action: {
                    let project = ProjectManager.shared.newProject()
                    selectedProjectId = project.id
                }, label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("New Session")
                    }
                })
                // Sessions
                ForEach($projects.projects, id: \.id) { project in
                    NavigationLink(
                        tag: project.wrappedValue.id,
                        selection: $selectedProjectId,
                        destination: {
                            if let project = projects.projects.first(where: { $0.id == selectedProjectId }) {
                                SessionView(data: project)
                            } else {
                                Text("Error")
                            }
                        },
                        label: {
                            Button(action: {
                                selectedProjectId = project.wrappedValue.id
                            }, label: {
                                Text(project.wrappedValue.description)
                            })
                        })
                }.onDelete(perform: { index in
                    projects.projects.remove(atOffsets: index)
                    projects.objectWillChange.send()
                    selectedProjectId = nil
                })
            }
            .listStyle(.plain)
            .navigationTitle("Sessions")
            .toolbar {
                Button(action: {
                    let project = ProjectManager.shared.newProject()
                    selectedProjectId = project.id
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
    }
}

struct Previews_ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
