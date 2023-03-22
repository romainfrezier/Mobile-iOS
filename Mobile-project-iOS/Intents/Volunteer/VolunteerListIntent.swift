//
//  VolunteerIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation
import SwiftUI

struct VolunteerListIntent {
    
    @ObservedObject private var volunteerListVM : VolunteerListViewModel
    
    init(volunteerListVM : VolunteerListViewModel){
        self.volunteerListVM = volunteerListVM
    }

    func load() {
        volunteerListVM.state = .loading
        Task {
            await self.loadAux()
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedDataAux(result : APIResult<VolunteerViewModel>){
        switch result {
        case .successList(let volunteers):
            volunteerListVM.state = .load(volunteers)
        default:
            volunteerListVM.state = .failed(.apiError)
        }
        
    }
    
    func loadAux() async {
        APITools.loadFromAPI(endpoint: "volunteers", callback: self.loadedDataAux, apiReturn: returnType.array.rawValue)
    }

}
