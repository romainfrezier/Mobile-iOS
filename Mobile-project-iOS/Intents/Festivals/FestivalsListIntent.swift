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
    
    init(festivalsListVM: FestivalsListViewModel){
        self.festivalsListVM = festivalsListVM
    }
    
    func load() {
        festivalsListVM.state = .loading
        Task {
            await self.loadAux()
        }
    }
    
    func loadOther(firebaseId: String) {
        festivalsListVM.state = .loading
        Task {
            await self.loadOtherAux(firebaseId: firebaseId)
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

    
    func loadOtherAux(firebaseId: String) async {
        APITools.loadFromAPI(endpoint: "festivals/others/" + firebaseId, callback: self.loadedData, apiReturn: returnType.array.rawValue)
    }
    
    func changeFestivalAux(volunteer: String, festival: String) async {
        let body: [String: Any] = ["festival":festival]
        await APITools.updateOnAPI(endpoint: "volunteers/changeFestival", id: volunteer, body: body)
        festivalsListVM.state = .idle
    }

    
    func deleteAux(id: String) async {
        APITools.removeOnAPI(endpoint: "festivals", id: id)
        festivalsListVM.state = .idle
    }
}
