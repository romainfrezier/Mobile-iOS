//
//  DayDTO.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation

struct DayDTO : Codable {
    var id : String
    var name : String
    var hours : HoursDTO
    var slots : Array<String>
    
    init(){
        self.id = ""
        self.name = ""
        self.hours = HoursDTO()
        self.slots = []
    }
    
    init(id: String, name: String, hours: HoursDTO, slots: Array<String>){
        self.id = id
        self.name = name
        self.hours = hours
        self.slots = slots
    }
    
    func getBody() -> [String : Any] {
        return [
            "name": self.name,
            "hours": self.hours,
            "slots": self.slots
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case hours
        case slots
    }
}

struct DayDetailedDTO : Codable, Hashable, Equatable {
    var id : String
    var name : String
    var hours : HoursDTO
    var slots : Array<SlotDTO>
    
    init(){
        self.id = ""
        self.name = ""
        self.hours = HoursDTO()
        self.slots = []
    }
    
    init(id: String, name: String, hours: HoursDTO, slots: Array<SlotDTO>){
        self.id = id
        self.name = name
        self.hours = hours
        self.slots = slots
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(self.id)
    }
    
    static func == (lhs: DayDetailedDTO, rhs: DayDetailedDTO) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getBody() -> [String : Any] {
        return [
            "name": self.name,
            "hours": self.hours,
            "slots": self.slots
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case hours
        case slots
    }
}

class HoursDTO : Codable {
    var opening: Date
    var closing: Date
    
    init(opening: Date, closing : Date){
        self.opening = opening
        self.closing = closing
    }
    
    init(){
        self.opening = Date()
        self.closing = Date()
    }
    
    enum CodingKeys : String, CodingKey {
        case opening
        case closing
    }
    
    func toString() -> String {
        String(describing: self)
    }
}
