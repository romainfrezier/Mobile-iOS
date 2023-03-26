//
//  SlotViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 26/03/2023.
//

import Foundation
import SwiftUI

class SlotViewModel: ObservableObject, Decodable, Hashable, Equatable {
    
    static func == (lhs: SlotViewModel, rhs: SlotViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<SlotDTO> = .idle {
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
    @Published var slot: SlotDTO
    
    init() {
        self.id = ""
        self.slot = SlotDTO()
    }
    
    init(id: String, slot: SlotDTO) {
        self.id = id
        self.slot = SlotDTO(id: slot.id, start: slot.start, end: slot.end, volunteers: slot.volunteers)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: SlotDTO.CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        let start = try values.decode(Date.self, forKey: .start)
        let end = try values.decode(Date.self, forKey: .end)
        let volunteers = try values.decode(Array<String>.self, forKey: .volunteers)
        self.slot = SlotDTO(id: self.id, start: start, end: end, volunteers: volunteers)
    }
}
