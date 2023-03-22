//
//  VolunteerListViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation

class VolunteerListViewModel: ObservableObject {
    
    @Published var state: APIStates<VolunteerViewModel> = .idle {
        didSet {
            switch state {
            case .load(let volunteers):
                self.volunteers = volunteers
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("VolunteerListViewModel state : \(self.state.description)")
                break
            }
        }
    }

    @Published var volunteers : [VolunteerViewModel];
    
    init(volunteers: [VolunteerViewModel]) {
        self.volunteers = volunteers
    }
    
    init() {
        self.volunteers = []
    }
}
