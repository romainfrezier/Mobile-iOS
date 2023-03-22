//
//  AvailableSlotsListViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation

class AvailableSlotsListViewModel: ObservableObject {
    
    @Published var state: APIStates<AvailableSlotViewModel> = .idle {
        didSet {
            switch state {
            case .load(let slots):
                self.availableSlots = slots
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("AvailableSlotsListViewModel state : \(self.state.description)")
                break
            }
        }
    }

    @Published var availableSlots : [AvailableSlotViewModel];
    
    init(availableSlots: [AvailableSlotViewModel]) {
        self.availableSlots = availableSlots
    }
    
    init() {
        self.availableSlots = []
    }
}
