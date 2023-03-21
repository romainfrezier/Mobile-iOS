//
//  SlotDTO.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation

struct SlotDTO : Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case start
        case end
        case volunteers
    }
}
