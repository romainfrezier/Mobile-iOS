//
//  DayIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import Foundation
import SwiftUI

struct DayIntent {
    
    @ObservedObject private var dayVM : DayViewModel
    
    init(dayVM: DayViewModel) {
        self.dayVM = dayVM
    }
    
    func create(festivalID: String, name: String, opening: Date, closing: Date) {
        dayVM.state = .creating
        Task {
            await self.createAux(festivalID: festivalID, name: name, opening: opening, closing: closing)
        }
        dayVM.state = .idle
    }
    
    func update(id: String, name: String) {
        dayVM.state = .updating
        Task {
            await self.updateAux(id: id, name: name)
        }
        dayVM.state = .idle
    }
    
    // MARK: - Aux async function to call API
    
    func createAux(festivalID: String, name: String, opening: Date, closing: Date) async {
        let data : [String: Any] = [
            "name": name,
            "hours": [
                "opening": opening.toJSONString(),
                "closing": closing.toJSONString()
            ]
        ]
        APITools.createOnAPI(endpoint: "days/" + festivalID, body: data)
    }
    
    func updateAux(id: String, name: String) async {
        let data : [String: Any] = [
            "name": name
        ]
        APITools.updateOnAPI(endpoint: "days/", id: id, body: data)
    }
}
