//
//  SessionManager.swift
//  Patch Roulette Watch WatchKit Extension
//
//  Created by Cem Olcay on 10/24/22.
//

import UIKit
import WatchConnectivity

class SessionManager: NSObject, WCSessionDelegate {
    let session: WCSession
    
    override init() {
        session = WCSession.default
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func requestProjects(compilation: (([HPData]) -> Void)?) {
        do {
            let message = ["message": WatchMessage.requestProjects.rawValue]
            let data = try JSONSerialization.data(withJSONObject: message)
            session.sendMessageData(data, replyHandler: { reply in
                do {
                    let projects = try JSONDecoder().decode([HPData].self, from: reply)
                    compilation?(projects)
                } catch {
                    compilation?([])
                }
            })
        } catch {
            compilation?([])
        }
    }
    
    func selectProject(project: HPData, compilation: ((HPData) -> Void)?) {
        do {
            let message: [String: Any] = [
                "message": WatchMessage.selectProject.rawValue,
                "projectID": project.id
            ]
            let data = try JSONSerialization.data(withJSONObject: message)
            session.sendMessageData(data, replyHandler: { projectData in
                do {
                    let project = try JSONDecoder().decode(HPData.self, from: projectData)
                    compilation?(project)
                } catch {
                    return
                }
            })
        } catch {
            return
        }
    }
    
    func newProject(compilation: ((HPData) -> Void)?) {
        do {
            let message: [String: Any] = ["message": WatchMessage.newProject.rawValue]
            let data = try JSONSerialization.data(withJSONObject: message)
            session.sendMessageData(data, replyHandler: { projectData in
                do {
                    let project = try JSONDecoder().decode(HPData.self, from: projectData)
                    compilation?(project)
                } catch {
                    return
                }
            })
        } catch {
            return
        }
    }
    
    func saveData(type: String, result: String) {
        do {
            let message: [String: Any] = [
                "message": WatchMessage.saveData.rawValue,
                "data": [
                    "type": type,
                    "result": result
                ]
            ]
            let data = try JSONSerialization.data(withJSONObject: message)
            session.sendMessageData(data, replyHandler: nil)
        } catch {
            return
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
}
