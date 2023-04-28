//
//  ProjectView.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct SessionView: View {
    @ObservedObject var data: HPData
    
    var body: some View {
        VStack {
            Text(data.description)
            HStack {
                Text("Layup")
                Text($data.layupScores.wrappedValue.count.description).foregroundColor(.green)
                Text($data.layupMisses.wrappedValue.count.description).foregroundColor(.red)
            }
            HStack {
                Text("2P")
                Text(data.twoPointScores.count.description).foregroundColor(.green)
                Text(data.twoPointMisses.count.description).foregroundColor(.red)
            }
            HStack {
                Text("3P")
                Text(data.threePointScores.count.description).foregroundColor(.green)
                Text(data.threePointMisses.count.description).foregroundColor(.red)
            }
        }
        .padding()
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
