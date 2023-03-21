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
    var zones : Array<ZoneDTO>
    var days : Array<DayDTO>

    
    init(id: String, name: String, zones: Array<ZoneDTO>, days: Array<DayDTO>) {
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
    
    func getBody() -> [String : Any] {
        let zonesBody: [Any] = []
        for zone in zones {
            zonesBody.append(zone.getObject())
        }
        let daysBody: [Any] = []
        for day in days {
            daysBody.append(day.getObject())
        }
        return [
            "name": self.name,
            "zones": zonesBody,
            "days": daysBody
        ]
    }

}
