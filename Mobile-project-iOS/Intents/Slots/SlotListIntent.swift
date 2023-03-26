//
//  SlotListIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 26/03/2023.
//

import Foundation
import SwiftUI

struct SlotListIntent {

    @ObservedObject var slotsVM : SlotsListViewModel
    
    
    init(slotsVM : SlotsListViewModel) {
        self.slotsVM = slotsVM
    }
    
    func loadNotAvailable(volunteer: String) {
        slotsVM.state = .loading
        Task {
            await self.loadNotAvailableAux(volunteer: volunteer)
        }
    }
    
    func loadAssigned(volunteerID: String) {
        slotsVM.state = .loading
        Task {
            await self.loadAssignedAux(volunteerID: volunteerID)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedDataAux(result : APIResult<SlotViewModel>){
        switch result {
        case .successList(let slots):
            slotsVM.state = .load(slots)
        default:
            slotsVM.state = .failed(.apiError)
        }
        
    }
    
    func loadNotAvailableAux(volunteer: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/notAvailableSlots/" + volunteer, callback: loadedDataAux, apiReturn: returnType.array.rawValue)
    }
    
    func loadAssignedAux(volunteerID: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/assignedSlots/" + volunteerID, callback: self.loadedDataAux, apiReturn: returnType.array.rawValue)
    }
}
