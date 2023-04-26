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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(data.description)
        }
        .padding()
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(data: .init())
    }
}
