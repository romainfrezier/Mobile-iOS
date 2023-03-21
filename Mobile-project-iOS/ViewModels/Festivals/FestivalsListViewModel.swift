//
//  FestivalsListViewModel.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation

class FestivalsListViewModel: ObservableObject{
    @Published var state: APIStates<FestivalViewModel> = .idle {
        didSet {
            switch state {
            case .load(let festivals):
                self.festivals = festivals
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("FestivalsListViewModel state : \(self.state)")
                break
            }
        }
    }

    @Published var festivals : [FestivalViewModel];
    
    init(festivals: [FestivalViewModel]) {
        self.festivals = festivals
    }
    
    init() {
        self.festivals = []
    }
}
