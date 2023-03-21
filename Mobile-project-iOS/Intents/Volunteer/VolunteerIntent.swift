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
    
    
    init(volunteerVM: VolunteerViewModel, volunteerListVM : VolunteerListViewModel){
        self.volunteerVM = volunteerVM
        self.volunteerListVM = volunteerListVM
    }
    
    init(vm: VolunteerListViewModel) {
        self.volunteerListVM = vm
        self.volunteerVM = VolunteerViewModel()
    }

    func load() {
        volunteerListVM.state = .loading
        Task {
            await self.loadAux()
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
    
    func updateAux(volunteer: VolunteerDTO) async {
        let data : [String: Any] = volunteer.getBody()
        APITools.updateOnAPI(endpoint: "volunteers", id: volunteer.id, body: data)
        volunteerVM.state = .idle
    }
    
    func deleteAux(id: String) async {
        APITools.removeOnAPI(endpoint: "volunteers", id: id)
        volunteerVM.state = .idle
    }

}
