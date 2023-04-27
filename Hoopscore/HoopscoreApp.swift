//
//  HoopscoreApp.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

@main
struct HoopscoreApp: App {
    
    init() {
        _ = WatchSessionManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
