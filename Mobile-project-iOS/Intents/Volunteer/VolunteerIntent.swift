//
//  VolunteerIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation
import SwiftUI

struct VolunteerIntent {
    
    @ObservedObject private var volunteerVM : VolunteerViewModel
    
    init(volunteerVM : VolunteerViewModel) {
        self.volunteerVM = volunteerVM
    }
    
    func loadOne(id: String) {
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
