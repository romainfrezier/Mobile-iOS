//
//  SlotsDetailedListIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation
import SwiftUI

struct SlotsDetailedListIntent {

    @ObservedObject var slotsVM : SlotsDetailedListViewModel
    
    
    init(slotsVM : SlotsDetailedListViewModel) {
        self.slotsVM = slotsVM
    }
    
    func loadAvailable(id: String) {
        slotsVM.state = .loading
        Task {
            await self.loadAvailableAux(id: id)
        }
    }
    
    func loadAssigned(volunteerID: String) {
        slotsVM.state = .loading
        Task {
            await self.loadAssignedAux(volunteerID: volunteerID)
        }
    }
    
    func free(volunteer: String, slot: String) {
        slotsVM.state = .updating
        Task {
            await self.freeAux(volunteer: volunteer, slot: slot)
        }
    }
    
    func assign(volunteer: String, slot: String, zone: String) {
        slotsVM.state = .updating
        Task {
            await self.assignAux(volunteer: volunteer, slot: slot, zone: zone)
        }
    }
    
    func loadNotAvailable(volunteer: String) {
        slotsVM.state = .loading
        Task {
            await self.loadNotAvailableAux(volunteer: volunteer)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedDataAux(result : APIResult<SlotDetailedViewModel>){
        switch result {
        case .successList(let slots):
            slotsVM.state = .load(slots)
        default:
            slotsVM.state = .failed(.apiError)
        }
        
    }
    
    func loadAvailableAux(id: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/availableSlots/" + id, callback: self.loadedDataAux, apiReturn: returnType.array.rawValue)
    }
    
    func loadAssignedAux(volunteerID: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/assignedSlots/" + volunteerID, callback: self.loadedDataAux, apiReturn: returnType.array.rawValue)
    }
    
    func freeAux(volunteer: String, slot: String) async {
        let body : [String: Any] = [
            "slot": slot
        ]
        APITools.updateOnAPI(endpoint: "volunteers/free", id: volunteer, body: body){
            result in
            switch result {
            case .success(_):
                slotsVM.state = .idle
            case .failure(_):
                slotsVM.state = .failed(.apiError)
            }
        }
    }
    
    func assignAux(volunteer: String, slot: String, zone: String) async {
        let body : [String: Any] = [
            "slot": slot,
            "zone": zone
        ]
        APITools.updateOnAPI(endpoint: "volunteers/assign", id: volunteer, body: body){
            result in
            switch result {
            case .success(_):
                slotsVM.state = .idle
            case .failure(_):
                slotsVM.state = .failed(.apiError)
            }
        }
    }
    
    func loadNotAvailableAux(volunteer: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/notAvailableSlots/" + volunteer, callback: loadedDataAux, apiReturn: returnType.array.rawValue)
    }
}
