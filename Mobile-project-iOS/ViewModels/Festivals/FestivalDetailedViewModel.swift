//
//  FestivalDetailedViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation

class FestivalDetailedViewModel: ObservableObject, Decodable, Hashable, Equatable {
    
    static func == (lhs: FestivalDetailedViewModel, rhs: FestivalDetailedViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<FestivalDetailedDTO> = .idle {
        didSet{
            switch state {
            case .loadOne(let festival):
                self.festival = festival
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("FestivalDetailedViewModel state : \(self.state)")
                break
            }
        }
    }
    
    var id: String
    @Published var festival: FestivalDetailedDTO
    
    init() {
        self.id = ""
        self.festival = FestivalDetailedDTO()
    }
    
    init(id: String, name: String, zones: Array<ZoneDTO>, days: Array<DayDetailedDTO>) {
        self.id = id
        self.festival = FestivalDetailedDTO(id: id, name: name, zones: zones, days: days)
    }
    
    init(festivalVM: FestivalViewModel){
        self.id = festivalVM.id
        self.festival = FestivalDetailedDTO(id: festivalVM.id, name: festivalVM.festival.name, zones: [], days: [])
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FestivalDTO.CodingKeys.self)
        let name = try values.decode(String.self, forKey: .name)
        let zones = try values.decode(Array<ZoneDTO>.self, forKey: .zones)
        let days = try values.decode(Array<DayDetailedDTO>.self, forKey: .days)
        id = try values.decode(String.self, forKey: .id)
        festival = FestivalDetailedDTO(id: id, name: name, zones: zones, days: days)
    }
}
