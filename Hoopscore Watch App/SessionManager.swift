//
//  SessionManager.swift
//  Patch Roulette Watch WatchKit Extension
//
//  Created by Cem Olcay on 10/24/22.
//

import UIKit
import WatchConnectivity

class SessionManager: NSObject, WCSessionDelegate {
    static let shared = SessionManager()
    let session: WCSession
    
    override init() {
        session = WCSession.default
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func requestProjects(compilation: (([HPWatchData]) -> Void)?) {
        let message = ["message": WatchMessage.requestProjects.rawValue]
        session.sendMessage(message, replyHandler: { reply in
            guard let data = reply["data"] as? Data,
                  let projects = try? JSONDecoder().decode([HPWatchData].self, from: data)
            else { return }
            compilation?(projects)
        })
    }
    
    func requestProject(projectId: String, compilation: ((HPWatchData) -> Void)?) {
        let message: [String: Any] = [
            "message": WatchMessage.selectProject.rawValue,
            "projectID": projectId
        ]
        session.sendMessage(message, replyHandler: { reply in
            guard let data = reply["data"] as? Data,
                  let project = try? JSONDecoder().decode(HPWatchData.self, from: data)
            else { return }
            compilation?(project)
        })
    }
    
    func newProject(compilation: ((HPWatchData) -> Void)?) {
        let message: [String: Any] = ["message": WatchMessage.newProject.rawValue]
        session.sendMessage(message, replyHandler: { reply in
            guard let data = reply["data"] as? Data,
                  let project = try? JSONDecoder().decode(HPWatchData.self, from: data)
            else { return }
            compilation?(project)
        })
    }
    
    func saveData(type: HPShootType, result: HPShootResult) {
        let message: [String: Any] = [
            "message": WatchMessage.saveData.rawValue,
            "data": [
                "type": type.rawValue,
                "result": result.rawValue
            ]
        ]
        session.sendMessage(message, replyHandler: nil)
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
}
