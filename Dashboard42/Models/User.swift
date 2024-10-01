//
//  User.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let email: String
    let login: String
    let url: String
    let displayname: String
    let image: Self.Image
    let correctionPoint: Int
    let poolMonth: String
    let poolYear: String
    let location: String?
    let wallet: Int
    let cursusUsers: [Self.Cursus]
    let projectsUsers: [Self.Projects]
    let achievements: [Self.Achievements]
    let titles: [Self.Titles]
    let patroned: [Self.Patronages]
    let patroning: [Self.Patronages]
    let campus: [Self.Campus]
    let campusUsers: [Self.CampusUsers]
    
    var mainCursus: Self.Cursus? {
        let studentCursus = cursusUsers.first(where: { $0.cursus.slug == "42cursus" })
        let piscineCursus = cursusUsers.first(where: { $0.cursus.slug == "c-piscine" })
        
        return studentCursus != nil ? studentCursus : piscineCursus
    }
    
    var mainCampus: Self.CampusUsers? { campusUsers.first(where: \.isPrimary) }
    
    var isPostCC: Bool {
        let lastProject = projectsUsers.first(where: { $0.project.slug == "ft_transcendence" })
        let lastExam = projectsUsers.first(where: { $0.project.slug == "exam-rank-06" })
        
        return lastProject?.validated == true && lastExam?.validated == true
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case login = "login"
        case url = "url"
        case displayname = "displayname"
        case image = "image"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case location = "location"
        case wallet = "wallet"
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
        case achievements = "achievements"
        case titles = "titles"
        case patroned = "patroned"
        case patroning = "patroning"
        case campus = "campus"
        case campusUsers = "campus_users"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: User.CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.login = try container.decode(String.self, forKey: .login)
        self.url = try container.decode(String.self, forKey: .url)
        self.displayname = try container.decode(String.self, forKey: .displayname)
        self.image = try container.decode(User.Image.self, forKey: .image)
        self.correctionPoint = try container.decode(Int.self, forKey: .correctionPoint)
        self.poolMonth = try container.decode(String.self, forKey: .poolMonth)
        self.poolYear = try container.decode(String.self, forKey: .poolYear)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.wallet = try container.decode(Int.self, forKey: .wallet)
        self.cursusUsers = try container.decode([User.Cursus].self, forKey: .cursusUsers)
        self.projectsUsers = try container.decode([User.Projects].self, forKey: .projectsUsers)
        self.achievements = try container.decode([User.Achievements].self, forKey: .achievements)
        self.titles = try container.decode([User.Titles].self, forKey: .titles)
        self.patroned = try container.decode([User.Patronages].self, forKey: .patroned)
        self.patroning = try container.decode([User.Patronages].self, forKey: .patroning)
        self.campus = try container.decode([User.Campus].self, forKey: .campus)
        self.campusUsers = try container.decode([User.CampusUsers].self, forKey: .campusUsers)
    }
}

extension User {
    // MARK: Image
    
    struct Image: Decodable {
        let link: String
        
        enum CodingKeys: String, CodingKey {
            case link = "link"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.link = try container.decode(String.self, forKey: .link)
        }
    }
    
    // MARK: Cursus
    
    struct Cursus: Identifiable, Decodable {
        let id: Int
        let grade: String?
        let level: Double
        let skills: [Self.Skills]
        let cursusId: Int
        let cursus: Self.Details
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case grade = "grade"
            case level = "level"
            case skills = "skills"
            case cursusId = "cursus_id"
            case cursus = "cursus"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.grade = try container.decodeIfPresent(String.self, forKey: .grade)
            self.level = try container.decode(Double.self, forKey: .level)
            self.skills = try container.decode([User.Cursus.Skills].self, forKey: .skills)
            self.cursusId = try container.decode(Int.self, forKey: .cursusId)
            self.cursus = try container.decode(User.Cursus.Details.self, forKey: .cursus)
        }
        
        struct Skills: Identifiable, Decodable {
            let id: Int
            let name: String
            let level: Double
            
            enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
                case level = "level"
            }
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(Int.self, forKey: .id)
                self.name = try container.decode(String.self, forKey: .name)
                self.level = try container.decode(Double.self, forKey: .level)
            }
        }
        
        struct Details: Identifiable, Decodable {
            let id: Int
            let name: String
            let slug: String
            
            enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
                case slug = "slug"
            }
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(Int.self, forKey: .id)
                self.name = try container.decode(String.self, forKey: .name)
                self.slug = try container.decode(String.self, forKey: .slug)
            }
        }
    }
    
    // MARK: Projects
    
    struct Projects: Identifiable, Decodable {
        let id: Int
        let occurrence: Int
        let finalMark: Int?
        let status: String
        let validated: Bool?
        let project: Self.Details
        let cursusIds: [Int]
        let markedAt: Date?
        let marked: Bool
        let retriableAt: Date?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case occurrence = "occurrence"
            case finalMark = "final_mark"
            case status = "status"
            case validated = "validated?"
            case project = "project"
            case cursusIds = "cursus_ids"
            case markedAt = "marked_at"
            case marked = "marked"
            case retriableAt = "retriable_at"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.occurrence = try container.decode(Int.self, forKey: .occurrence)
            self.finalMark = try container.decodeIfPresent(Int.self, forKey: .finalMark)
            self.status = try container.decode(String.self, forKey: .status)
            self.validated = try container.decodeIfPresent(Bool.self, forKey: .validated)
            self.project = try container.decode(User.Projects.Details.self, forKey: .project)
            self.cursusIds = try container.decode([Int].self, forKey: .cursusIds)
            self.markedAt = try container.decodeIfPresent(Date.self, forKey: .markedAt)
            self.marked = try container.decode(Bool.self, forKey: .marked)
            self.retriableAt = try container.decodeIfPresent(Date.self, forKey: .retriableAt)
        }
        
        struct Details: Identifiable, Decodable {
            let id: Int
            let name: String
            let slug: String
            
            enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
                case slug = "slug"
            }
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(Int.self, forKey: .id)
                self.name = try container.decode(String.self, forKey: .name)
                self.slug = try container.decode(String.self, forKey: .slug)
            }
        }
    }
    
    // MARK: Achievements
    
    struct Achievements: Identifiable, Decodable {
        let id: Int
        let name: String
        let description: String
        let kind: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case description = "description"
            case kind = "kind"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.description = try container.decode(String.self, forKey: .description)
            self.kind = try container.decode(String.self, forKey: .kind)
        }
    }
    
    // MARK: Titles
    
    struct Titles: Identifiable, Decodable {
        let id: Int
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
        }
    }
    
    // MARK: Patronages
    
    struct Patronages: Identifiable, Decodable {
        let id: Int
        let userId: Int
        let godfatherId: Int
        let ongoing: Bool
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case userId = "user_id"
            case godfatherId = "godfather_id"
            case ongoing = "ongoing"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.userId = try container.decode(Int.self, forKey: .userId)
            self.godfatherId = try container.decode(Int.self, forKey: .godfatherId)
            self.ongoing = try container.decode(Bool.self, forKey: .ongoing)
        }
    }
    
    // MARK: Campus
    
    struct Campus: Identifiable, Decodable {
        let id: Int
        let name: String
        let country: String
        let address: String
        let zip: String
        let city: String
        let website: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case country = "country"
            case address = "address"
            case zip = "zip"
            case city = "city"
            case website = "website"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.country = try container.decode(String.self, forKey: .country)
            self.address = try container.decode(String.self, forKey: .address)
            self.zip = try container.decode(String.self, forKey: .zip)
            self.city = try container.decode(String.self, forKey: .city)
            self.website = try container.decode(String.self, forKey: .website)
        }
    }
    
    // MARK: Campus Users
    
    struct CampusUsers: Identifiable, Decodable {
        let id: Int
        let campusId: Int
        let isPrimary: Bool
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case campusId = "campus_id"
            case isPrimary = "is_primary"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.campusId = try container.decode(Int.self, forKey: .campusId)
            self.isPrimary = try container.decode(Bool.self, forKey: .isPrimary)
        }
    }
}
