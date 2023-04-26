//
//  SessionManager.swift
//  PatchRoulette
//
//  Created by Cem Olcay on 10/24/22.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
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
    
    func handleData(message: Data, reply: ((Data) -> Void)? = nil) {
        do {
            guard let messageDict = try JSONSerialization.jsonObject(with: message) as? [String: Any],
                  let messageName = messageDict["message"] as? String,
                  let msg = WatchMessage(rawValue: messageName)
            else { return }
            switch msg {
            case .requestProjects:
                let projects = ProjectManager.shared.projects
                let data = try JSONEncoder().encode(projects.map({ $0.watchFriendlyCopy() }))
                reply?(data)
            case .selectProject:
                guard let projectID = messageDict["projectID"] as? UUID,
                      let project = ProjectManager.shared.projects.first(where: { $0.id == projectID })
                else { return }
                self.data = project
                let data = try JSONEncoder().encode(project)
                reply?(data)
            case .newProject:
                let project = ProjectManager.shared.newProject()
                self.data = project
                let data = try JSONEncoder().encode(project)
                reply?(data)
            case .saveData:
                guard let shootData = messageDict["data"] as? [String: Any],
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
        } catch {
            return
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        handleData(message: messageData)
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        handleData(message: messageData, reply: replyHandler)
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
