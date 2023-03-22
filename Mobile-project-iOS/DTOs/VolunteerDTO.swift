//
//  VolunteerDTO.swift
//  Mobile-project-iOS
//
//  Created by Romain on 09/03/2023.
//

import Foundation

struct VolunteerDTO : Codable {
    var id : String
    var firstName : String
    var lastName : String
    var emailAddress : String
    var firebaseId : String
    var festivalId : String?
    var isAdmin : Bool
    var availableSlots: Array<AvailableSlotsDTO>
    
    init(id: String, firstName: String, lastName: String, emailAddress: String, firebaseId: String, festivalId: String?, isAdmin: Bool, availableSlots: Array<AvailableSlotsDTO>) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.firebaseId = firebaseId
        self.festivalId = festivalId
        self.isAdmin = isAdmin
        self.availableSlots = availableSlots
    }
    
    init(){
        self.id = ""
        self.firstName = ""
        self.lastName = ""
        self.emailAddress = ""
        self.firebaseId = ""
        self.festivalId = nil
        self.isAdmin = false
        self.availableSlots = []
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case lastName
        case firstName
        case emailAddress = "email"
        case firebaseId
        case festivalId = "festival"
        case isAdmin
        case availableSlots
    }
    
    func getBody() -> [String : Any] {
        return [
            "firstName" : self.firstName,
            "lastName" : self.lastName,
            "emailAddress" : self.emailAddress,
            "festival" : self.festivalId ?? "",
            "availableSlots" : self.availableSlots
        ]
    }
    
    func toString() -> String {
        String(describing: self)
    }
}

struct AvailableSlotsDTO : Codable {
    var id: String
    var slot: String
    var zone: String?
    
    init(id: String, slot: String, zone : String?){
        self.slot = slot
        self.zone = zone
        self.id = id
    }
    
    init(){
        self.id = ""
        self.slot = ""
        self.zone = nil
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "_id"
        case zone
        case slot
    }
    
    func toString() -> String {
        String(describing: self)
    }
}

struct AvailableSlotsDetailedDTO : Codable, Hashable, Equatable {
    
    static func == (lhs: AvailableSlotsDetailedDTO, rhs: AvailableSlotsDetailedDTO) -> Bool {
        return lhs.slot.id == rhs.slot.id
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(self.slot.id)
    }
    
    var slot : SlotDTO
    var zone : ZoneDTO?
    var id : String
    
    init(id: String, slot: SlotDTO, zone : ZoneDTO?){
        self.slot = slot
        self.zone = zone
        self.id = id
    }
    
    init(){
        self.id = ""
        self.slot = SlotDTO()
        self.zone = nil
    }
    
    enum CodingKeys : String, CodingKey {
        case zone
        case slot
        case id = "_id"
    }
    
    func toString() -> String {
        String(describing: self)
    }
}
