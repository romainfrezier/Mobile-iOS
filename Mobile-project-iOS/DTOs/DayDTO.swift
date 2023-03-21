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
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case volunteersNumber
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
}
