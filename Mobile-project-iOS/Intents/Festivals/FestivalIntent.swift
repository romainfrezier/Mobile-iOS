//
//  FestivalIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import Foundation
import SwiftUI

struct FestivalIntent {
    
    @ObservedObject private var festivalVM : FestivalViewModel
    
    init(festivalVM: FestivalViewModel) {
        self.festivalVM = festivalVM
    }
    
    init(){
        self.festivalVM = FestivalViewModel()
    }
    
    func loadOne(id: String) {
        festivalVM.state = .loading
        Task {
            await self.loadOneAux(id: id)
        }
    }
    
    func create(name: String) {
        festivalVM.state = .creating
        Task {
            await self.createAux(name: name)
        }
    }
    
    func updateName(festivalID: String, newName: String) {
        festivalVM.state = .updating
        Task {
            await self.updateNameAux(festivalID: festivalID, newName: newName)
        }
    }
    
    func deleteZone(id: String) {
        festivalVM.state = .deleting
        Task {
            await self.deleteZoneAux(id: id)
        }
    }
    
    // MARK: - Aux async function to call API
    
    func loadOneData(result: APIResult<FestivalViewModel>) -> Void {
        switch result {
        case .success(let festival):
            self.festivalVM.state = .loadOne(festival.festival)
        default:
            self.festivalVM.state = .failed(.apiError)
        }
    }
    
    func loadOneAux(id: String) async {
        APITools.loadFromAPI(endpoint: "festivals/" + id, callback: loadOneData, apiReturn: returnType.object.rawValue)
    }
    
    func createAux(name: String) async {
        let data : [String: Any] = ["name": name]
        APITools.createOnAPI(endpoint: "festivals", body: data)
        festivalVM.state = .idle
    }

    func updateNameAux(festivalID: String, newName: String) async {
        let data : [String: Any] = [
            "name": newName
        ]
        APITools.updateOnAPI(endpoint: "festivals/name", id: festivalID, body: data){
            result in
            switch result {
            case .success(_):
                festivalVM.state = .idle
            case .failure(_):
                festivalVM.state = .failed(.apiError)
            }
        }
    }
    
    func deleteZoneAux(id: String) async {
        APITools.removeOnAPI(endpoint: "zones", id: id)
    }
}
