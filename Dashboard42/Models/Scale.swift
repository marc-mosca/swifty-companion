//
//  Scale.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import Foundation

struct Scale: Identifiable, Decodable {
    let id: Int
    let scaleId: Int
    let beginAt: Date
    let correcteds: Self.CorrectedsType?
    let corrector: Self.CorrectorType?
    let scale: Self.Details
    let teams: Self.Team?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case scaleId = "scale_id"
        case beginAt = "begin_at"
        case correcteds = "correcteds"
        case corrector = "corrector"
        case scale = "scale"
        case teams = "teams"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.scaleId = try container.decode(Int.self, forKey: .scaleId)
        self.beginAt = try container.decode(Date.self, forKey: .beginAt)
        
        if let correctedString = try? container.decode(String.self, forKey: .correcteds) {
            self.correcteds = .string(correctedString)
        }
        else if let userList = try? container.decode([Scale.User].self, forKey: .correcteds) {
            self.correcteds = .userList(userList)
        }
        else {
            self.correcteds = nil
        }
        
        if let correctorString = try? container.decode(String.self, forKey: .corrector) {
            self.corrector = .string(correctorString)
        }
        else if let user = try? container.decode(Scale.User.self, forKey: .corrector) {
            self.corrector = .user(user)
        }
        else {
            self.corrector = nil
        }
        
        self.scale = try container.decode(Scale.Details.self, forKey: .scale)
        self.teams = try container.decodeIfPresent(Scale.Team.self, forKey: .teams)
    }
}

extension Scale {
    enum CorrectedsType: Codable {
        case string(String)
        case userList([Scale.User])
    }
    
    enum CorrectorType: Codable {
        case string(String)
        case user(Scale.User)
    }
    
    struct User: Codable, Identifiable {
        let id: Int
        let login: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case login = "login"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.login = try container.decode(String.self, forKey: .login)
        }
    }
    
    struct Details: Codable, Identifiable {
        let id: Int
        let correctionNumber: Int
        let duration: Int
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case correctionNumber = "correction_number"
            case duration = "duration"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.correctionNumber = try container.decode(Int.self, forKey: .correctionNumber)
            self.duration = try container.decode(Int.self, forKey: .duration)
        }
    }
    
    struct Team: Codable, Identifiable {
        let id: Int
        let name: String
        let projectId: Int
        let status: String
        let users: [Self.User]
        let locked: Bool
        let validated: Bool?
        let closed: Bool
        let lockedAt: Date?
        let closedAt: Date?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case projectId = "project_id"
            case status = "status"
            case users = "users"
            case locked = "locked"
            case validated = "validated"
            case closed = "closed"
            case lockedAt = "locked_at"
            case closedAt = "closed_at"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.projectId = try container.decode(Int.self, forKey: .projectId)
            self.status = try container.decode(String.self, forKey: .status)
            self.users = try container.decode([Scale.Team.User].self, forKey: .users)
            self.locked = try container.decode(Bool.self, forKey: .locked)
            self.validated = try container.decodeIfPresent(Bool.self, forKey: .validated)
            self.closed = try container.decode(Bool.self, forKey: .closed)
            self.lockedAt = try container.decodeIfPresent(Date.self, forKey: .lockedAt)
            self.closedAt = try container.decodeIfPresent(Date.self, forKey: .closedAt)
        }
        
        struct User: Codable, Identifiable {
            let id: Int
            let login: String
            let leader: Bool
            
            enum CodingKeys: String, CodingKey {
                case id = "id"
                case login = "login"
                case leader = "leader"
            }
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(Int.self, forKey: .id)
                self.login = try container.decode(String.self, forKey: .login)
                self.leader = try container.decode(Bool.self, forKey: .leader)
            }
        }
    }
}
