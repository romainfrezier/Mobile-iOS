//
//  AvailableSlotsListIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation
import SwiftUI

struct AvailableSlotsListIntent {

    @ObservedObject var availableSlotsVM : AvailableSlotsListViewModel
    
    
    init(availableSlotsVM : AvailableSlotsListViewModel) {
        self.availableSlotsVM = availableSlotsVM
    }
    
    func load(id: String) {
        availableSlotsVM.state = .loading
        Task {
            await self.loadAux(id: id)
        }
    }
    
    func free(volunteer: String, slot: String) {
        availableSlotsVM.state = .updating
        Task {
            await self.freeAux(volunteer: volunteer, slot: slot)
        }
    }
    
    func assign(volunteer: String, slot: String, zone: String) {
        availableSlotsVM.state = .updating
        Task {
            await self.assignAux(volunteer: volunteer, slot: slot, zone: zone)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedDataAux(result : APIResult<AvailableSlotViewModel>){
        switch result {
        case .successList(let slots):
            availableSlotsVM.state = .load(slots)
        default:
            availableSlotsVM.state = .failed(.apiError)
        }
        
    }
    
    func loadAux(id: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/availableSlots/" + id, callback: self.loadedDataAux, apiReturn: returnType.array.rawValue)
    }
    
    func freeAux(volunteer: String, slot: String) async {
        let body : [String: Any] = [
            "slot": slot
        ]
        APITools.updateOnAPI(endpoint: "volunteers/free", id: volunteer, body: body)
    }
    
    func assignAux(volunteer: String, slot: String, zone: String) async {
        let body : [String: Any] = [
            "slot": slot,
            "zone": zone
        ]
        APITools.updateOnAPI(endpoint: "volunteers/assign", id: volunteer, body: body)
    }
}
