//
//  SessionView.swift
//  Hoopscore Watch Watch App
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct SessionView: View {
    var manager: SessionManager
    var data: HPData
    @State var isLoading: Bool = true

    init(data: HPData, manager: SessionManager) {
        self.data = data
        self.manager = manager
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

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        let data = HPData(
            layupScores: [Date(), Date()],
            layupMisses: [Date(), Date(), Date()],
            twoPointScores: [Date()],
            twoPointMisses: [Date(), Date()])
        SessionView(data: data, manager: SessionManager())
    }
}
