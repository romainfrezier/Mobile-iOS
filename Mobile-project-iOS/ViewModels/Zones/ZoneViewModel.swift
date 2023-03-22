//
//  ZoneViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation

class ZoneViewModel: ObservableObject, Decodable, Hashable, Equatable {
    
    static func == (lhs: ZoneViewModel, rhs: ZoneViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<ZoneDTO> = .idle {
        didSet{
            switch state {
            case.loadOne(let zone):
                self.zone = zone
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("VolunteerViewModel state : \(self.state)")
                break
            }
        }
    }
    
    var id: String
    @Published var zone: ZoneDTO
    
    init() {
        self.id = ""
        self.zone = ZoneDTO()
    }
    
    init(id: String, zone: ZoneDTO) {
        self.id = id
        self.zone = zone
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ZoneDTO.CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        let number = try values.decode(Int.self, forKey: .volunteersNumber)
        self.zone = ZoneDTO(id: self.id, name: name, volunteersNumber: number)
    }
}
