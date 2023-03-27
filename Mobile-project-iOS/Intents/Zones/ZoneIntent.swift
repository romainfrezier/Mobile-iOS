//
//  ZoneIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import Foundation
import SwiftUI

struct ZoneIntent {
    
    @ObservedObject private var zoneVM : ZoneViewModel
    
    init(zoneVM: ZoneViewModel) {
        self.zoneVM = zoneVM
    }
    
    func create(festivalID: String, name: String, volunteerNumber: Int) {
        zoneVM.state = .creating
        Task {
            await self.createAux(festivalID: festivalID, name: name, volunteerNumber: volunteerNumber)
        }
        zoneVM.state = .idle
    }
    
    func update(id: String, name: String, volunteerNumber: Int) {
        zoneVM.state = .updating
        Task {
            await self.updateAux(id: id, name: name, volunteerNumber: volunteerNumber)
        }
    }
    
    // MARK: - Aux async function to call API
    
    func createAux(festivalID: String, name: String, volunteerNumber: Int) async {
        let data : [String: Any] = [
            "name": name,
            "volunteersNumber": volunteerNumber
        ]
        APITools.createOnAPI(endpoint: "zones/" + festivalID, body: data)
    }
    
    func updateAux(id: String, name: String, volunteerNumber: Int) async {
        let data : [String: Any] = [
            "name": name,
            "volunteersNumber": volunteerNumber
        ]
        APITools.updateOnAPI(endpoint: "zones/", id: id, body: data){
            result in
            switch result {
            case .success(_):
                zoneVM.state = .idle
            case .failure(_):
                zoneVM.state = .failed(.apiError)
            }
        }
    }
}
