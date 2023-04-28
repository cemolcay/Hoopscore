//
//  SessionManager.swift
//  PatchRoulette
//
//  Created by Cem Olcay on 10/24/22.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    let session: WCSession
    var data: HPData
    
    override init() {
        session = WCSession.default
        data = HPData()
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func handleMessage(_ message: [String: Any], reply: (([String: Any]) -> Void)? = nil) {
        guard let messageName = message["message"] as? String,
              let msg = WatchMessage(rawValue: messageName)
        else { return }
        
        switch msg {
        case .requestProjects:
            let projects = ProjectManager.shared.projects
            guard let data = try? JSONEncoder().encode(projects.map({ HPWatchData(data: $0) })) else { return }
            reply?(["data": data])
            
        case .selectProject:
            guard let projectID = message["projectID"] as? String,
                  let project = ProjectManager.shared.projects.first(where: { $0.id == projectID }),
                  let data = try? JSONEncoder().encode(HPWatchData(data: project))
            else { return }
            self.data = project
            reply?(["data": data])
                    
        case .newProject:
            DispatchQueue.main.async {
                let project = ProjectManager.shared.newProject()
                guard let data = try? JSONEncoder().encode(project) else { return }
                self.data = project
                reply?(["data": data])
            }
            
        case .saveData:
            guard let shootData = message["data"] as? [String: Any],
                  let typeData = shootData["type"] as? Int,
                  let type = HPShootType(rawValue: typeData),
                  let resultData = shootData["result"] as? Int,
                  let result = HPShootResult(rawValue: resultData)
            else { return }
            
            DispatchQueue.main.async {
                self.data.shoots.append(HPShoot(type: type, result: result))
                ProjectManager.shared.update(project: self.data)
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        handleMessage(message, reply: replyHandler)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}
