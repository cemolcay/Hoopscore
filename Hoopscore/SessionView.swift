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
        let layupScores = $data.shoots.wrappedValue.filter({ $0.type == .layup && $0.result == .score }).count
        let layupMisses = $data.shoots.wrappedValue.filter({ $0.type == .layup && $0.result == .miss }).count
        let twoPointScores = $data.shoots.wrappedValue.filter({ $0.type == .twoPoint && $0.result == .score }).count
        let twoPointMisses = $data.shoots.wrappedValue.filter({ $0.type == .twoPoint && $0.result == .miss }).count
        let threePointScores = $data.shoots.wrappedValue.filter({ $0.type == .threePoint && $0.result == .score }).count
        let threePointMisses = $data.shoots.wrappedValue.filter({ $0.type == .threePoint && $0.result == .miss }).count

        VStack {
            Text(data.description)
            HStack {
                Text("Layup")
                Text(layupScores.description).foregroundColor(.green)
                Text(layupMisses.description).foregroundColor(.red)
            }
            HStack {
                Text("2P")
                Text(twoPointScores.description).foregroundColor(.green)
                Text(twoPointMisses.description).foregroundColor(.red)
            }
            HStack {
                Text("3P")
                Text(threePointScores.description).foregroundColor(.green)
                Text(threePointMisses.description).foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        let data = HPData(
            shoots: [
                .init(type: .layup, result: .score),
                .init(type: .layup, result: .score),
                .init(type: .layup, result: .miss),
                .init(type: .layup, result: .miss),
                .init(type: .layup, result: .miss),
                .init(type: .twoPoint, result: .score),
                .init(type: .twoPoint, result: .miss),
                .init(type: .twoPoint, result: .miss),
                .init(type: .threePoint, result: .score),
                .init(type: .threePoint, result: .score),
                .init(type: .threePoint, result: .miss),
            ])
        NavigationView {
            SessionView(data: data)
        }
    }
}
