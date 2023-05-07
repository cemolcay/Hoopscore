//
//  ProjectView.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI
import Charts

struct SessionView: View {
    @ObservedObject var data: HPData
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                Group {
                    Text("Shoot Type")
                    Chart(data.scoreTypeSeries()) { series in
                        ForEach(series.score) { score in
                            LineMark(x: .value("Date", score.date, unit: .second),
                                     y: .value("Score", score.score))
                            .foregroundStyle(by: .value("Type", series.name))
                            .interpolationMethod(.linear)
                            PointMark(x: .value("Date", score.date, unit: .second),
                                      y: .value("Score", score.score))
                            .foregroundStyle(by: .value("Type", series.name))
                            .symbol(by: .value("Type", series.name))
                        }
                    }
                }
                Group {
                    Text("Shoot Result")
                    Chart(data.scoreResultSeries()) { series in
                        ForEach(series.result) { result in
                            BarMark(
                                x: .value("Type", series.name),
                                y: .value("Count", result.count)
                            )
                            .position(by: .value("Result", result.name))
                            .foregroundStyle(by: .value("Result", result.name))
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(data.description)
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        let data = HPData.randomData()
        NavigationView {
            SessionView(data: data)
        }
    }
}
