//
//  SessionView.swift
//  Hoopscore Watch Watch App
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct SessionView: View {
    @State var layupScore: Int
    @State var layupMiss: Int
    @State var twoPointScore: Int
    @State var twoPointMiss: Int
    @State var threePointScore: Int
    @State var threePointMiss: Int
    var title: String
    
    init(data: HPData) {
        title = data.description
        layupScore = data.layupScores.count
        layupMiss = data.layupMisses.count
        twoPointScore = data.twoPointScores.count
        twoPointMiss = data.twoPointMisses.count
        threePointScore = data.threePointScores.count
        threePointMiss = data.threePointMisses.count
    }
    
    var body: some View {
        let textWidth: CGFloat = 48
        VStack(alignment: .leading) {
            HStack {
                Text("Layup").frame(width: textWidth)
                Button(action: {
                    self.layupScore += 1
                    SessionManager.shared.saveData(type: "layup", result: "score")
                }, label: {
                    VStack{
                        Text("Score")
                        Text($layupScore.wrappedValue.description)
                    }
                }).foregroundColor(.green)
                Button(action: {
                    self.layupMiss += 1
                    SessionManager.shared.saveData(type: "layup", result: "miss")
                }, label: {
                    VStack{
                        Text("Miss")
                        Text($layupMiss.wrappedValue.description)
                    }
                }).foregroundColor(.red)
            }
            HStack {
                Text("2P").frame(width: textWidth)
                Button(action: {
                    self.twoPointScore += 1
                    SessionManager.shared.saveData(type: "twoPoint", result: "score")
                }, label: {
                    VStack{
                        Text("Score")
                        Text($twoPointScore.wrappedValue.description)
                    }
                }).foregroundColor(.green)
                Button(action: {
                    self.twoPointMiss += 1
                    SessionManager.shared.saveData(type: "twoPoint", result: "miss")
                }, label: {
                    VStack{
                        Text("Miss")
                        Text($twoPointMiss.wrappedValue.description)
                    }
                }).foregroundColor(.red)
            }
            HStack {
                Text("3P").frame(width: textWidth)
                Button(action: {
                    threePointScore += 1
                    SessionManager.shared.saveData(type: "threePoint", result: "score")
                }, label: {
                    VStack{
                        Text("Score")
                        Text($threePointScore.wrappedValue.description)
                    }
                }).foregroundColor(.green)
                Button(action: {
                    threePointMiss += 1
                    SessionManager.shared.saveData(type: "threePoint", result: "miss")
                }, label: {
                    VStack{
                        Text("Miss")
                        Text($threePointMiss.wrappedValue.description)
                    }
                }).foregroundColor(.red)
            }
        }
        .navigationTitle({
            Text(title)
        })
    }
}

struct SessionRequestView: View {
    @State var isLoading: Bool = true
    @State var data: HPData?
    var projectId: String?
    
    init(projectId: String?) {
        self.projectId = projectId
    }
    
    var body: some View {
        ZStack {
            if let data = $data.wrappedValue {
                SessionView(data: data)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .overlay(content: {
            if $isLoading.wrappedValue {
                VStack() {
                    ProgressView()
                    Text("Loading")
                }.background(content: { Color(.black) })
            }
        })
        .onAppear(perform: {
            requestProject()
        })
    }
    
    func requestProject() {
        if let projectId = projectId {
            SessionManager.shared.requestProject(
                projectId: projectId,
                compilation: { data in
                    self.isLoading = false
                    self.data = data
                })
        } else {
            SessionManager.shared.newProject(compilation: { data in
                self.isLoading = false
                self.data = data
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
        NavigationView {
            SessionView(data: data)
        }
    }
}
