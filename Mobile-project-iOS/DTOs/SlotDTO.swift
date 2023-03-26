//
//  SlotDTO.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation

struct SlotDTO : Codable, Hashable {
    var id : String
    var start : Date
    var end : Date
    var volunteers: Array<String>
    
    init(){
        self.id = ""
        self.start = Date()
        self.end = Date()
        self.volunteers = []
    }
    
    init(id: String, start: Date, end: Date, volunteers: Array<String>){
        self.id = id
        self.start = start
        self.end = end
        self.volunteers = volunteers
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(self.id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case start
        case end
        case volunteers
    }
    
    func toString() -> String {
        String(describing: self)
    }
}

struct SlotDetailedDTO : Codable, Hashable, Equatable {
    var id : String
    var start : Date
    var end : Date
    var volunteers: Array<VolunteerDTO>
    
    init(){
        self.id = ""
        self.start = Date()
        self.end = Date()
        self.volunteers = []
    }
    
    init(id: String, start: Date, end: Date, volunteers: Array<VolunteerDTO>){
        self.id = id
        self.start = start
        self.end = end
        self.volunteers = volunteers
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(self.id)
    }
    
    static func == (lhs: SlotDetailedDTO, rhs: SlotDetailedDTO) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case start
        case end
        case volunteers
    }
    
    func toString() -> String {
        String(describing: self)
    }
}
