//
//  WatchMessage.swift
//  Hoopscore
//
//  Created by Cem Olcay on 4/26/23.
//

import Foundation

enum WatchMessage: String, Codable {
    case requestProjects
    case selectProject
    case newProject
    case saveData
}
