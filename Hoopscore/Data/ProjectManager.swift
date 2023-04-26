//
//  ProjectManager.swift
//  StepBud
//
//  Created by cem.olcay on 14/02/2019.
//  Copyright © 2019 cemolcay. All rights reserved.
//

import Foundation
import Disk

class ProjectManager: ObservableObject {
    static let shared = ProjectManager()
        
    @Published var projects = [HPData]() {
        didSet {
            do {
                try Disk.save(projects, to: .documents, as: "projects")
            } catch {
                return
            }
        }
    }
    
    init() {
        do {
            projects = try Disk.retrieve("projects", from: .documents, as: [HPData].self)
        } catch {
            projects = [HPData()]
        }
    }
    
    func newProject() -> HPData {
        let project = HPData()
        var newProjects = projects
        newProjects.append(project)
        projects = newProjects
        return project
    }
    
    func update(project: HPData) {
        guard let index = projects.firstIndex(where: { $0.id == project.id })
        else { return }
        projects[index] = project
    }
}
