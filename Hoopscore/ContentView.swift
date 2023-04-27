//
//  ContentView.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import SwiftUI

struct ContentView: View {  
    var body: some View {
        NavigationView {
            ProjectsView()
            Text("Select a project")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 mini")
    }
}
