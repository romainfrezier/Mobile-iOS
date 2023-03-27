//
//  FestivalsListIntent.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation
import SwiftUI

struct FestivalsListIntent{
    
    @ObservedObject private var festivalsListVM : FestivalsListViewModel
    @ObservedObject private var volunteerVM : VolunteerViewModel
    
    init(festivalsListVM: FestivalsListViewModel, volunteerVM: VolunteerViewModel){
        self.festivalsListVM = festivalsListVM
        self.volunteerVM = volunteerVM
    }
    
    init(festivalsListVM: FestivalsListViewModel){
        self.festivalsListVM = festivalsListVM
        self.volunteerVM = VolunteerViewModel()
    }
    
    func load() {
        festivalsListVM.state = .loading
        Task {
            await self.loadAux()
        }
    }
    
    func loadOther(volunteerId: String) {
        festivalsListVM.state = .loading
        Task {
            await self.loadOtherAux(volunteerId: volunteerId)
        }
    }
    
    func changeFestival(volunteer: String, festival: String){
        festivalsListVM.state = .updating
        Task{
            await self.changeFestivalAux(volunteer: volunteer, festival: festival)
        }
    }
    
    
    
    func delete(id: String) {
        festivalsListVM.state = .deleting
        Task {
            await self.deleteAux(id:id)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedData(result : APIResult<FestivalViewModel>){
        switch result{
        case .successList(let festivals):
            festivalsListVM.state = .load(festivals)
        default:
            festivalsListVM.state = .failed(.apiError)
        }
    }
    
    func loadAux() async {
        APITools.loadFromAPI(endpoint: "festivals", callback: self.loadedData, apiReturn: returnType.array.rawValue)
    }

    
    func loadOtherAux(volunteerId: String) async {
        APITools.loadFromAPI(endpoint: "festivals/others/" + volunteerId, callback: self.loadedData, apiReturn: returnType.array.rawValue)
    }
    
    func changeFestivalAux(volunteer: String, festival: String) async {
        let body: [String: Any] = ["festival":festival]
        APITools.updateOnAPI(endpoint: "volunteers/changeFestival", id: volunteer, body: body) {
            result in
            switch result {
            case .success(_):
                self.volunteerVM.state = .updateFestival(festival)
            case .failure(_):
                festivalsListVM.state = .failed(.apiError)
            }
        }
        
    }

    
    func deleteAux(id: String) async {
        APITools.removeOnAPI(endpoint: "festivals", id: id)
        festivalsListVM.state = .idle
    }
}
