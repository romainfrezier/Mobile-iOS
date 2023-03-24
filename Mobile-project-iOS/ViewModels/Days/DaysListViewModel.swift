//
//  DaysListViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import Foundation

class DaysListViewModel : ObservableObject {
    
    @Published var state: APIStates<DayViewModel> = .idle {
        didSet {
            switch state {
            case .load(let days):
                self.days = days
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("DaysListViewModel state : \(self.state.description)")
                break
            }
        }
    }

    @Published var days : [DayViewModel];
    
    init(days: [DayViewModel]) {
        self.days = days
    }
    
    init() {
        self.days = []
    }
}
