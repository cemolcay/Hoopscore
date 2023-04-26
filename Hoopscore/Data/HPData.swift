//
//  HPData.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import Foundation

class HPData: Identifiable, Codable, CustomStringConvertible, ObservableObject {
    var id: UUID
    var date: Date
    var layupScores: [Date]
    var layupMisses: [Date]
    var twoPointScores: [Date]
    var twoPointMisses: [Date]
    var threePointScores: [Date]
    var threePointMisses: [Date]
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         layupScores: [Date] = [],
         layupMisses: [Date] = [],
         twoPointScores: [Date] = [],
         twoPointMisses: [Date] = [],
         threePointScores: [Date] = [],
         threePointMisses: [Date] = []) {
        self.id = id
        self.date = date
        self.layupScores = layupScores
        self.layupMisses = layupMisses
        self.twoPointScores = twoPointScores
        self.twoPointMisses = twoPointMisses
        self.threePointScores = threePointScores
        self.threePointMisses = threePointMisses
    }
    
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func watchFriendlyCopy() -> HPData {
        return HPData(id: id, date: date)
    }
}
