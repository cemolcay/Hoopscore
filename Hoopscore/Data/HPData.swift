//
//  HPData.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import Foundation

class HPWatchData: Identifiable, Codable, ObservableObject {
    var id: String
    var title: String
    @Published var layupScores: Int
    @Published var layupMisses: Int
    @Published var twoPointScores: Int
    @Published var twoPointMisses: Int
    @Published var threePointScores: Int
    @Published var threePointMisses: Int
    
    init(data: HPData) {
        self.id = data.id
        self.title = data.description
        self.layupScores = data.shoots.filter({ $0.type == .layup && $0.result == .score }).count
        self.layupMisses = data.shoots.filter({ $0.type == .layup && $0.result == .miss }).count
        self.twoPointScores = data.shoots.filter({ $0.type == .twoPoint && $0.result == .score }).count
        self.twoPointMisses = data.shoots.filter({ $0.type == .twoPoint && $0.result == .miss }).count
        self.threePointScores = data.shoots.filter({ $0.type == .threePoint && $0.result == .score }).count
        self.threePointMisses = data.shoots.filter({ $0.type == .threePoint && $0.result == .miss }).count
    }
    
    // MARK: Codable
    
    enum CodingKeys: CodingKey {
        case id
        case title
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
         self.title = try container.decode(String.self, forKey: .title)
         self.layupScores = try container.decode(Int.self, forKey: .layupScores)
         self.layupMisses = try container.decode(Int.self, forKey: .layupMisses)
         self.twoPointScores = try container.decode(Int.self, forKey: .twoPointScores)
         self.twoPointMisses = try container.decode(Int.self, forKey: .twoPointMisses)
         self.threePointScores = try container.decode(Int.self, forKey: .threePointScores)
         self.threePointMisses = try container.decode(Int.self, forKey: .threePointMisses)
     }
  
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(self.id, forKey: .id)
         try container.encode(self.title, forKey: .title)
         try container.encode(self.layupScores, forKey: .layupScores)
         try container.encode(self.layupMisses, forKey: .layupMisses)
         try container.encode(self.twoPointScores, forKey: .twoPointScores)
         try container.encode(self.twoPointMisses, forKey: .twoPointMisses)
         try container.encode(self.threePointScores, forKey: .threePointScores)
         try container.encode(self.threePointMisses, forKey: .threePointMisses)
     }
}

enum HPShootType: Int, Codable, CaseIterable, CustomStringConvertible {
    case layup
    case twoPoint
    case threePoint
    
    var description: String {
        switch self {
        case .layup: return "Layup"
        case .twoPoint: return "2P"
        case .threePoint: return "3P"
        }
    }
}

enum HPShootResult: Int, Codable, CaseIterable, CustomStringConvertible {
    case score
    case miss
    
    var description: String {
        switch self {
        case .score: return "Score"
        case .miss: return "Miss"
        }
    }
}

struct HPShoot: Identifiable, Codable {
    var id: String
    var date: Date
    var type: HPShootType
    var result: HPShootResult
    
    init(
        id: String = UUID().uuidString,
        date: Date = Date(),
        type: HPShootType,
        result: HPShootResult) {
        self.id = id
        self.date = date
        self.type = type
        self.result = result
    }
}

class HPData: Identifiable, Codable, CustomStringConvertible, ObservableObject {
    var id: String
    var date: Date
    @Published var shoots: [HPShoot]
    
    init(id: String = UUID().uuidString,
         date: Date = Date(),
         shoots: [HPShoot] = []) {
        self.id = id
        self.date = date
        self.shoots = shoots
    }
    
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func randomData(count: Int = 50, intervalMin: TimeInterval = 20, intervalMax: TimeInterval = 90) -> HPData {
        var date = Date()
        var shots: [HPShoot] = []
        for _ in 0..<count {
            shots.append(HPShoot(
                date: date,
                type: HPShootType.allCases.randomElement()!,
                result: HPShootResult.allCases.randomElement()!))
            let interval = TimeInterval.random(in: intervalMin...intervalMax)
            date += interval
        }
        let data = HPData()
        data.shoots = shots
        return data
    }
    
    // MARK: Codable
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case shoots
    }
    
    required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.id = try container.decode(String.self, forKey: .id)
         self.date = try container.decode(Date.self, forKey: .date)
         self.shoots = try container.decode([HPShoot].self, forKey: .shoots)
     }
  
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(self.id, forKey: .id)
         try container.encode(self.date, forKey: .date)
         try container.encode(self.shoots, forKey: .shoots)
     }
}
