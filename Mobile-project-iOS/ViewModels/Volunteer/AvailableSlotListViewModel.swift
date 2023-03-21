//
//  AvailableSlotListViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation

class AvailableSlotListViewModel: ObservableObject, Decodable {
    
    @Published var state: APIStates<AvailableSlotsDetailedDTO> = .idle {
        didSet {
            switch state {
            case .load(let slots):
                self.availableSlots = slots
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("VolunteerListViewModel state : \(self.state)")
                break
            }
        }
    }

    @Published var availableSlots : [AvailableSlotsDetailedDTO];
    
    init(availableSlots: [AvailableSlotsDetailedDTO]) {
        self.availableSlots = availableSlots
    }
    
    init() {
        self.availableSlots = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AvailableSlotsDetailedDTO.CodingKeys.self)
        let slot = try values.decode(SlotDTO.self, forKey: .slot)
        let zone = try values.decode(ZoneDTO.self, forKey: .zone)
        self.availableSlots = []
        self.availableSlots.append(AvailableSlotsDetailedDTO(slot: slot, zone: zone))
    }
}
