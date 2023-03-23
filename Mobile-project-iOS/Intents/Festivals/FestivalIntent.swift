//
//  FestivalIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import Foundation
import SwiftUI

struct FestivalIntent {
    
    @ObservedObject private var festivalVM : FestivalDetailedViewModel
    
    init(festivalVM: FestivalDetailedViewModel) {
        self.festivalVM = festivalVM
    }
    
    func loadOne(id: String) {
        festivalVM.state = .loading
        Task {
            await self.loadOneAux(id: id)
        }
    }
    
    func create(festival: FestivalDetailedDTO) {
        festivalVM.state = .creating
        Task {
            await self.createAux(festival: festival)
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
    
    func loadOneData(result: APIResult<FestivalDetailedViewModel>) -> Void {
        switch result {
        case .success(let festival):
            self.festivalVM.state = .loadOne(festival.festival)
        default:
            self.festivalVM.state = .failed(.apiError)
        }
    }
    
    func loadOneAux(id: String) async {
        APITools.loadFromAPI(endpoint: "festivals/full/" + id, callback: loadOneData, apiReturn: returnType.object.rawValue)
    }
    
    func createAux(festival: FestivalDetailedDTO) async {
//        let data : [String: Any] = festival.getBody()
        let data : [String: Any] = [:]
        APITools.createOnAPI(endpoint: "festivals", body: data)
        festivalVM.state = .idle
    }

    func updateNameAux(festivalID: String, newName: String) async {
        let data : [String: Any] = [
            "name": newName
        ]
        APITools.updateOnAPI(endpoint: "festivals/name", id: festivalID, body: data)
        festivalVM.state = .idle
    }
    
    func deleteZoneAux(id: String) async {
        APITools.removeOnAPI(endpoint: "zones", id: id)
    }
}
