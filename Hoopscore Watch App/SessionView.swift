//
//  SessionView.swift
//  Hoopscore Watch Watch App
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct SessionView: View {
    var data: HPData
    
    init(data: HPData) {
        self.data = data
    }
    
    var body: some View {
        VStack {
            Text(data.description)
            HStack {
                Text("Layup")
                Text(data.layupMisses.count.description)
                Text(data.layupScores.count.description)
            }
            HStack {
                Text("2P")
                Text(data.twoPointMisses.count.description)
                Text(data.twoPointScores.count.description)
            }
            HStack {
                Text("3P")
                Text(data.threePointMisses.count.description)
                Text(data.threePointScores.count.description)
            }
        }
    }
}

struct SessionRequestView: View {
    @State var isLoading: Bool = true
    @State var projectId: UUID?
    @State var data: HPData?
    
    init(projectId: UUID?) {
        self.projectId = projectId
    }
    
    var body: some View {
        VStack {
            if let data = data {
                SessionView(data: data)
            }
        }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        ).onAppear(perform: {
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
    }
    
    func reload() {
        if let projectId = projectId {
            SessionManager.shared.requestProject(
                projectId: projectId,
                compilation: { data in
                    self.data = data
                    self.isLoading = false
                })
        } else {
            SessionManager.shared.newProject(compilation: { data in
                self.data = data
                self.projectId = data.id
                self.isLoading = false
            })
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        let data = HPData(
            layupScores: [Date(), Date()],
            layupMisses: [Date(), Date(), Date()],
            twoPointScores: [Date()],
            twoPointMisses: [Date(), Date()])
        SessionView(data: data)
    }
}
