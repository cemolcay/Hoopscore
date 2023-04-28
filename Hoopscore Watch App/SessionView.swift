//
//  SessionView.swift
//  Hoopscore Watch Watch App
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct SessionView: View {
    @ObservedObject var data: HPWatchData
    
    var body: some View {
        let textWidth: CGFloat = 48
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 8) {
                Text("🏀").frame(width: textWidth)
                Text("Score").foregroundColor(.green).padding()
                Text("Miss").foregroundColor(.red).padding()
            }
            HStack {
                Text("Layup").frame(width: textWidth)
                Button(action: {
                    data.layupScores += 1
                    SessionManager.shared.saveData(type: "layup", result: "score")
                }, label: {
                    Text($data.layupScores.wrappedValue.description)
                }).foregroundColor(.green)
                Button(action: {
                    data.layupMisses += 1
                    SessionManager.shared.saveData(type: "layup", result: "miss")
                }, label: {
                    Text($data.layupMisses.wrappedValue.description)
                }).foregroundColor(.red)
            }
            HStack {
                Text("2P").frame(width: textWidth)
                Button(action: {
                    data.twoPointScores += 1
                    SessionManager.shared.saveData(type: "twoPoint", result: "score")
                }, label: {
                    Text($data.twoPointScores.wrappedValue.description)
                }).foregroundColor(.green)
                Button(action: {
                    data.twoPointMisses += 1
                    SessionManager.shared.saveData(type: "twoPoint", result: "miss")
                }, label: {
                    Text($data.twoPointMisses.wrappedValue.description)
                }).foregroundColor(.red)
            }
            HStack {
                Text("3P").frame(width: textWidth)
                Button(action: {
                    data.threePointScores += 1
                    SessionManager.shared.saveData(type: "threePoint", result: "score")
                }, label: {
                    Text($data.threePointScores.wrappedValue.description)
                }).foregroundColor(.green)
                Button(action: {
                    data.threePointMisses += 1
                    SessionManager.shared.saveData(type: "threePoint", result: "miss")
                }, label: {
                    Text($data.threePointMisses.wrappedValue.description)
                }).foregroundColor(.red)
            }
        }
        .navigationTitle(data.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SessionRequestView: View {
    @State var isLoading: Bool = true
    @State var data: HPWatchData?
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            SessionView(data: HPWatchData(data: data))
        }
    }
}
