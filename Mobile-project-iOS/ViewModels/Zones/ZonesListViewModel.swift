//
//  ZonesListViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation

class ZonesListViewModel: ObservableObject {
    
    @Published var state: APIStates<ZoneViewModel> = .idle {
        didSet {
            switch state {
            case .load(let zones):
                self.zones = zones
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("ZonesListViewModel state : \(self.state.description)")
                break
            }
        }
    }

    @Published var zones : [ZoneViewModel];
    
    init(zones: [ZoneViewModel]) {
        self.zones = zones
    }
    
    init() {
        self.zones = []
    }
}
