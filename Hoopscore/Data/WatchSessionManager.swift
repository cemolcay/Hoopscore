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
            guard let data = try? JSONEncoder().encode(projects.map({ $0.watchFriendlyCopy() }))
            else { return }
            session.sendMessage(["projects": data], replyHandler: nil)
            reply?(["projects": data])
            
        case .selectProject:
            guard let projectID = message["projectID"] as? UUID,
                  let project = ProjectManager.shared.projects.first(where: { $0.id == projectID }),
                  let data = try? JSONEncoder().encode(project)
                  //let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            else { return }
            self.data = project
            reply?(["project": data])
                    
        case .newProject:
            let project = ProjectManager.shared.newProject()
            guard let data = try? JSONEncoder().encode(project)
                  //let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            else { return }
            self.data = project
            reply?(["project": data])
                    
        case .saveData:
            guard let shootData = message["data"] as? [String: Any],
                  let type = shootData["type"] as? String,
                  let result = shootData["result"] as? String
            else { return }
            if type == "layup" {
                if result == "score" {
                    data.layupScores.append(Date())
                } else if result == "miss" {
                    data.layupMisses.append(Date())
                }
            } else if type == "twoPoint" {
                if result == "score" {
                    data.twoPointScores.append(Date())
                } else if result == "miss" {
                    data.twoPointMisses.append(Date())
                }
            } else if type == "threePoint" {
                if result == "score" {
                    data.threePointScores.append(Date())
                } else if result == "miss" {
                    data.threePointMisses.append(Date())
                }
            } else {
                return
            }
            
            ProjectManager.shared.update(project: data)
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
