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
    
    func load(firebaseId: String) {
        volunteerVM.state = .loading
        Task {
            await self.loadOneAuxByFirebaseID(firebaseId: firebaseId)
        }
    }

    func create(firebaseId : String, firstName : String, lastName : String, email : String){
        volunteerVM.state = .creating
        Task {
            await self.createAux(firebaseId : firebaseId, firstName : firstName, lastName : lastName, email : email);
        }
    }
    
    func loadOne(id: String) {
        volunteerVM.state = .loading
        Task {
            await self.loadOneAux(id: id)
        }
    }

    func update(id: String, firstName: String, lastName: String) {
        volunteerVM.state = .updating
        Task {
            await self.updateAux(id: id, firstName: firstName, lastName: lastName)
        }
    }
    
    func addSlot(id: String, slotID: String) {
        Task {
            await addSlotAux(id: id, slotID: slotID)
        }
    }
    
    func removeSlot(id: String, slotID: String) {
        Task {
            await removeSlotAux(id: id, slotID: slotID)
        }
    }
    
    func setFestival(id: String, festivalID: String){
        volunteerVM.state = .updating
        Task {
            await self.setFestivalAux(id: id, festivalID: festivalID)
        }
    }

    func delete(id: String) {
        volunteerVM.state = .deleting
        Task {
            await self.deleteAux(id: id)
        }
    }

    // MARK: - Aux async function to call API
    
    func loadedOneData(result : APIResult<VolunteerDTO>){
        switch result {
        case .success(let volunteer):
            volunteerVM.state = .loadOne(volunteer)
        default:
            volunteerVM.state = .failed(.apiError)
        }
    }
    
    func loadOneAux(id : String) async {
        APITools.loadFromAPI(endpoint: "volunteers/" + id, callback: self.loadedOneData, apiReturn: returnType.object.rawValue)
    }
    
    func loadOneAuxByFirebaseID(firebaseId: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/firebase/" + firebaseId, callback: self.loadedOneData, apiReturn: returnType.object.rawValue)
    }
    
    func updateAux(id: String, firstName: String, lastName: String) async {
        let data : [String: Any] = ["firstName": firstName, "lastName": lastName]
        APITools.updateOnAPI(endpoint: "volunteers", id: id, body: data)
        volunteerVM.state = .idle
    }
    
    func addSlotAux(id: String, slotID: String) async {
        let data : [String: Any] = [
            "newSlot": slotID
        ]
        APITools.updateOnAPI(endpoint: "volunteers/addSlot", id: id, body: data)
    }
    
    func removeSlotAux(id: String, slotID: String) async {
        let data : [String: Any] = [
            "removedSlot": slotID
        ]
        APITools.updateOnAPI(endpoint: "volunteers/removeSlot", id: id, body: data)
    }
    
    func setFestivalAux(id: String, festivalID: String) async {
        let data : [String:Any] = ["festival": festivalID]
        APITools.updateOnAPI(endpoint: "volunteers", id: id, body: data)
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

    func createAux(firebaseId : String, firstName : String, lastName : String, email : String) async {
        let body : [String : Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "firebaseId": firebaseId
        ]
        APITools.createOnAPI(endpoint: "volunteers", body: body)
        self.volunteerVM.state = .idle
    }
}
