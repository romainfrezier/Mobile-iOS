//
//  VolunteerIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation
import SwiftUI

struct VolunteerIntent {
    
    @ObservedObject private var volunteerVM : VolunteerViewModel
    @ObservedObject private var volunteerListVM : VolunteerListViewModel
    @ObservedObject var availableSlotsVM : AvailableSlotListViewModel
    
    
    init(volunteerVM: VolunteerViewModel, volunteerListVM : VolunteerListViewModel, availableSlots: AvailableSlotListViewModel){
        self.volunteerVM = volunteerVM
        self.volunteerListVM = volunteerListVM
        self.availableSlotsVM = availableSlots
    }
    
    init(vm: VolunteerListViewModel) {
        self.volunteerListVM = vm
        self.volunteerVM = VolunteerViewModel()
        self.availableSlotsVM = AvailableSlotListViewModel()
    }
    
    mutating func setAvailableSlots(availableSlotsVM : AvailableSlotListViewModel){
        self.availableSlotsVM = availableSlotsVM
    }

    func load() {
        volunteerListVM.state = .loading
        Task {
            await self.loadAux()
        }
    }
    
    func loadOne(id: String){
        volunteerVM.state = .loading
        Task {
            await self.loadOneAux(id: id)
        }
    }

    func update(volunteer: VolunteerDTO) {
        volunteerVM.state = .updating
        Task {
            await self.updateAux(volunteer: volunteer)
        }
    }

    func delete(id: String) {
        volunteerVM.state = .deleting
        Task {
            await self.deleteAux(id: id)
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
    
    func loadedOneDataAux(result : APIResult<VolunteerDTO>){
        switch result {
        case .success(let volunteer):
            volunteerVM.state = .loadOne(volunteer)
        default:
            volunteerVM.state = .failed(.apiError)
        }
        
    }
    
    func loadOneAux(id : String) async {
        APITools.loadFromAPI(endpoint: "volunteers/" + id, callback: self.loadedOneDataAux, apiReturn: returnType.object.rawValue)
    }
    
    func updateAux(volunteer: VolunteerDTO) async {
        let data : [String: Any] = volunteer.getBody()
        APITools.updateOnAPI(endpoint: "volunteers", id: volunteer.id, body: data)
        volunteerVM.state = .idle
    }
    
    func deleteAux(id: String) async {
        APITools.removeOnAPI(endpoint: "volunteers", id: id)
        volunteerVM.state = .idle
    }
    
    func loadedAvailableSlots(result: APIResult<AvailableSlotsDetailedDTO>){
        switch result {
        case .successList(let values) :
            availableSlotsVM.state = .load(values)
        default:
            availableSlotsVM.state = .failed(.apiError)
        }
    }
    
    func loadAvailableSlots(id : String){
        availableSlotsVM.state = .loading
        Task {
            await loadAvailableSlotsAux(id: id)
        }
    }
    
    func loadAvailableSlotsAux(id : String) async {
        APITools.loadFromAPI(endpoint: "volunteers/availableSlots/" + id, callback: loadedAvailableSlots, apiReturn: returnType.array.rawValue)
    }
    
    func makeAdmin(id : String){
        volunteerVM.state = .loading
        Task {
            await self.makeAdminAux(id: id)
        }
        volunteerVM.state = .idle
    }
    
    func makeAdminAux(id: String) async {
        APITools.updateOnAPI(endpoint: "volunteers/admin", id: id, body: [:])
    }

}
