//
//  HPData.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import Foundation

class HPData: Identifiable, Codable, CustomStringConvertible, ObservableObject {
    var id: String
    var date: Date
    @Published var layupScores: [Date]
    @Published var layupMisses: [Date]
    @Published var twoPointScores: [Date]
    @Published var twoPointMisses: [Date]
    @Published var threePointScores: [Date]
    @Published var threePointMisses: [Date]
    
    init(id: String = UUID().uuidString,
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
    
    // MARK: Codable
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case layupScores
        case layupMisses
        case twoPointScores
        case twoPointMisses
        case threePointScores
        case threePointMisses
    }
    
    required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.id = try container.decode(String.self, forKey: .id)
         self.date = try container.decode(Date.self, forKey: .date)
         self.layupScores = try container.decode([Date].self, forKey: .layupScores)
         self.layupMisses = try container.decode([Date].self, forKey: .layupMisses)
         self.twoPointScores = try container.decode([Date].self, forKey: .twoPointScores)
         self.twoPointMisses = try container.decode([Date].self, forKey: .twoPointMisses)
         self.threePointScores = try container.decode([Date].self, forKey: .threePointScores)
         self.threePointMisses = try container.decode([Date].self, forKey: .threePointMisses)
     }
  
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(self.id, forKey: .id)
         try container.encode(self.date, forKey: .date)
         try container.encode(self.layupScores, forKey: .layupScores)
         try container.encode(self.layupMisses, forKey: .layupMisses)
         try container.encode(self.twoPointScores, forKey: .twoPointScores)
         try container.encode(self.twoPointMisses, forKey: .twoPointMisses)
         try container.encode(self.threePointScores, forKey: .threePointScores)
         try container.encode(self.threePointMisses, forKey: .threePointMisses)
     }
}
