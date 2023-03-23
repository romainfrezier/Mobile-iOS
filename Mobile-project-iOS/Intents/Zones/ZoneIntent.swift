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
            print("Before Aux : ", volunteerNumber)
            await self.createAux(festivalID: festivalID, name: name, volunteerNumber: volunteerNumber)
        }
        zoneVM.state = .idle
    }
    
    // MARK: - Aux async function to call API
    
    func createAux(festivalID: String, name: String, volunteerNumber: Int) async {
        let data : [String: Any] = [
            "name": name,
            "volunteersNumber": volunteerNumber
        ]
        print("In Aux : ", data["volunteersNumber"]!)
        APITools.createOnAPI(endpoint: "zones/" + festivalID, body: data)
    }
}
