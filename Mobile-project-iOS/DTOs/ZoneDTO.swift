//
//  ZoneDTO.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation

struct ZoneDTO : Codable {
    var id : String
    var name : String
    var volunteersNumber : Int
    
    init(){
        self.id = ""
        self.name = ""
        self.volunteersNumber = 0
    }
    
    init(id: String, name: String, volunteersNumber: Int){
        self.id = id
        self.name = name
        self.volunteersNumber = volunteersNumber
    }
    
    func getBody() -> [String : Any] {
        return [
            "name": self.name,
            "volunteersNumber": self.volunteersNumber
        ]
    }
    
    func getObject() -> {String : Any} {
        return [
            "nom": self.name,
            "type": self.type ?? "",
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case volunteersNumber
    }
}
