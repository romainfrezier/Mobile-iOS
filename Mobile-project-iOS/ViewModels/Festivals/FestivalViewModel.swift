//
//  FestivalViewModel.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation

class FestivalViewModel: ObservableObject, Decodable, Hashable, Equatable {
    
    static func == (lhs: FestivalViewModel, rhs: FestivalViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<FestivalDTO> = .idle {
        didSet{
            switch state {
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("FestivalViewModel state : \(self.state)")
                break
            }
        }
    }
    
    var id: String
    @Published var festival: FestivalDTO
    
    init() {
        self.id = ""
        self.festival = FestivalDTO()
    }
    
    init(id: String, name: String, zones: Array<ZoneDTO>, days: Array<DayDTO>) {
        self.id = id
        self.festival = FestivalDTO(id: id, name: name, zones: zones, days: days)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FestivalDTO.CodingKeys.self)
        let name = try values.decode(String.self, forKey: .name)
        let zones = try values.decode(Array<ZoneDTO>.self, forKey: .zones)
        let days = try values.decode(Array<DayDTO>.self, forKey: .days)
        id = try values.decode(String.self, forKey: .id)
        festival = FestivalDTO(id: id, name: name, zones: zones, days: days)
    }
}
