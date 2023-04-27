//
//  HoopscoreApp.swift
//  Hoopscore Watch App
//
//  Created by Cem Olcay on 4/27/23.
//

import SwiftUI

@main
struct Hoopscore_Watch_App: App {
    
    init() {
        _ = SessionManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
