//
//  ChartData.swift
//  Hoopscore
//
//  Created by Cem Olcay on 5/7/23.
//

import Foundation

struct ScoreTypeData: Identifiable {
    var id: UUID
    var date: Date
    var score: Int
    
    init(date: Date, score: Int) {
        self.id = UUID()
        self.date = date
        self.score = score
    }
}

struct ScoreTypeSeries: Identifiable {
    var id: UUID
    var name: String
    var score: [ScoreTypeData]
    
    init(name: String, score: [ScoreTypeData]) {
        self.id = UUID()
        self.name = name
        self.score = score
    }
}

struct ScoreResultData: Identifiable {
    var id: UUID
    var name: String
    var count: Int
    
    init(name: String, count: Int) {
        self.id = UUID()
        self.name = name
        self.count = count
    }
}

struct ScoreResultSeries: Identifiable {
    var id: UUID
    var name: String
    var result: [ScoreResultData]
    
    init(name: String, result: [ScoreResultData]) {
        self.id = UUID()
        self.name = name
        self.result = result
    }
}

extension HPData {
    func scoreTypeData(for type: HPShootType) -> [ScoreTypeData] {
        var score = 0
        return shoots
            .filter({ $0.type == type })
            .sorted(by: { $0.date < $1.date })
            .map({
                if $0.result == .score { score += 1 }
                return ScoreTypeData(
                    date: $0.date,
                    score: score)
            })
    }
    
    func scoreTypeSeries() -> [ScoreTypeSeries] {
        return HPShootType.allCases.map({ ScoreTypeSeries(
            name: $0.description,
            score: scoreTypeData(for: $0))
        })
    }
    
    func scoreResultData(for type: HPShootType) -> [ScoreResultData] {
        let data = shoots.filter({ $0.type == type })
        return HPShootResult.allCases.map({ result in
            ScoreResultData(
                name: result.description,
                count: data.filter({ $0.result == result }).count)
        })
    }

    func scoreResultSeries() -> [ScoreResultSeries] {
        return HPShootType.allCases.map({ type in
            return ScoreResultSeries(
                name: type.description,
                result: scoreResultData(for: type))
        })
    }
}
