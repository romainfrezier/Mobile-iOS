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
            case .loadOne(let festival):
                self.festival = festival
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
    
    init(id: String, name: String, zones: Array<String>, days: Array<String>) {
        self.id = id
        self.festival = FestivalDTO(id: id, name: name, zones: zones, days: days)
    }
    
    init(festival: FestivalDTO){
        self.id = festival.id
        self.festival = festival
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FestivalDTO.CodingKeys.self)
        let name = try values.decode(String.self, forKey: .name)
        let zones = try values.decode(Array<String>.self, forKey: .zones)
        let days = try values.decode(Array<String>.self, forKey: .days)
        id = try values.decode(String.self, forKey: .id)
        festival = FestivalDTO(id: id, name: name, zones: zones, days: days)
    }

    func toEmptyDetailed() -> FestivalDetailedViewModel {
        let zones = self.festival.zones.map { zone in
            ZoneDTO(id: zone, name: "", volunteersNumber: 0)
        }
        let days = self.festival.days.map{ day in
            DayDetailedDTO(id: day, name: "", hours: HoursDTO(), slots: [])
        }
        return FestivalDetailedViewModel(id: self.id, name: self.festival.name, zones: zones, days: days)
    }
    
    func update(value: FestivalDTO) {
        self.festival = value
    }
}
