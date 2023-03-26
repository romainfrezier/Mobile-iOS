//
//  SlotsListViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation

class SlotsDetailedListViewModel: ObservableObject {
    
    @Published var state: APIStates<SlotDetailedViewModel> = .idle {
        didSet {
            switch state {
            case .load(let slots):
                self.slots = slots
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("AvailableSlotsListViewModel state : \(self.state.description)")
                break
            }
        }
    }

    @Published var slots : [SlotDetailedViewModel];
    
    init(slots: [SlotDetailedViewModel]) {
        self.slots = slots
    }
    
    init() {
        self.slots = []
    }
}
