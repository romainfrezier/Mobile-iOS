//
//  SlotsListViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 26/03/2023.
//

import SwiftUI

import Foundation

class SlotsListViewModel: ObservableObject {
    
    @Published var state: APIStates<SlotViewModel> = .idle {
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

    @Published var slots : [SlotViewModel];
    
    init(slots: [SlotViewModel]) {
        self.slots = slots
    }
    
    init() {
        self.slots = []
    }
}
