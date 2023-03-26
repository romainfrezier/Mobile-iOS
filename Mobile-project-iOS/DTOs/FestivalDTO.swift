//
//  FestivalDTO.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation

class FestivalDTO : Codable {
    var id : String
    var name : String
    var zones : Array<String>
    var days : Array<String>

    
    init(id: String, name: String, zones: Array<String>, days: Array<String>) {
        self.id = id
        self.name = name
        self.zones = zones
        self.days = days
    }
    
    init(){
        self.id = ""
        self.name = ""
        self.zones = []
        self.days = []
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case zones
        case days
    }
}
