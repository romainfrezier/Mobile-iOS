//
//  AssignedSlotViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 26/03/2023.
//

import Foundation
import SwiftUI

class AssignedSlotViewModel: ObservableObject, Decodable, Hashable, Equatable {
    
    static func == (lhs: AssignedSlotViewModel, rhs: AssignedSlotViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<SlotDetailedDTO> = .idle {
        didSet{
            switch state {
            case.loadOne(let slot):
                self.slot = slot
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("AvailableSlotViewModel state : \(self.state)")
                break
            }
        }
    }
    
    var id: String
    @Published var slot: SlotDetailedDTO
    
    init() {
        self.id = ""
        self.slot = SlotDetailedDTO()
    }
    
    init(id: String, slot: SlotDetailedDTO) {
        self.id = id
        self.slot = slot
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: SlotDetailedDTO.CodingKeys.self)
        let volunteers = try values.decode(Array<VolunteerDTO>.self, forKey: .volunteers)
        let start = try values.decode(Date.self, forKey: .start)
        let end = try values.decode(Date.self, forKey: .end)
        let id = try values.decode(String.self, forKey: .id)
        self.slot = SlotDetailedDTO(id: id, start: start, end: end, volunteers: volunteers)
        self.id = id
    }
}
