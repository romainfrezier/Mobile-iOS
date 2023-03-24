//
//  DayViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import Foundation

class DayViewModel : ObservableObject, Decodable, Hashable, Equatable {
    static func == (lhs: DayViewModel, rhs: DayViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<DayDetailedDTO> = .idle {
        didSet{
            switch state {
            case.loadOne(let day):
                self.day = day
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("DayViewModel state : \(self.state)")
                break
            }
        }
    }
    
    var id: String
    @Published var day: DayDetailedDTO
    
    init() {
        self.id = ""
        self.day = DayDetailedDTO()
    }
    
    init(id: String, day: DayDetailedDTO) {
        self.id = id
        self.day = day
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DayDetailedDTO.CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        let slots = try values.decode(Array<SlotDTO>.self, forKey: .slots)
        let hours = try values.decode(HoursDTO.self, forKey: .hours)
        self.day = DayDetailedDTO(id: self.id, name: name, hours: hours, slots: slots)
    }
}
