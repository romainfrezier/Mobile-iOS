//
//  AvailableSlotViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation
import SwiftUI

class AvailableSlotViewModel : ObservableObject, Decodable, Hashable, Equatable {
    
    static func == (lhs: AvailableSlotViewModel, rhs: AvailableSlotViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<AvailableSlotsDetailedDTO> = .idle {
        didSet{
            switch state {
            case.loadOne(let availableSlot):
                self.availableSlot = availableSlot
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
    @Published var availableSlot: AvailableSlotsDetailedDTO
    
    init() {
        self.id = ""
        self.availableSlot = AvailableSlotsDetailedDTO()
    }
    
    init(id: String, slot: SlotDTO, zone: ZoneDTO?) {
        self.id = id
        self.availableSlot = AvailableSlotsDetailedDTO(id: id, slot: slot, zone: zone)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AvailableSlotsDetailedDTO.CodingKeys.self)
        let slot = try values.decode(SlotDTO.self, forKey: .slot)
        let zone = try values.decode(ZoneDTO?.self, forKey: .zone)
        let id = try values.decode(String.self, forKey: .id)
        self.availableSlot = AvailableSlotsDetailedDTO(id: id, slot: slot, zone: zone)
        self.id = id
    }
}
