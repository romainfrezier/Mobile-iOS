//
//  VolunteerDTO.swift
//  Mobile-project-iOS
//
//  Created by Romain on 09/03/2023.
//

import Foundation

class VolunteerDTO : Codable {
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
    
//    func getBody() -> [String : Any] {
//        return [
//            "prenom": self.firstName,
//            "nom": self.lastName,
//            "email": self.emailAddress
//        ]
//    }
}

class AvailableSlotsDTO : Codable {
    var slot: String
    var zone: String?
    
    init(slot: String, zone : String?){
        self.slot = slot
        self.zone = zone
    }
    
    init(){
        self.slot = ""
        self.zone = nil
    }
    
    enum CodingKeys : String, CodingKey {
        case zone
        case slot
    }
}
