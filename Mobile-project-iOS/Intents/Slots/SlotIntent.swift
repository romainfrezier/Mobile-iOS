//
//  SlotIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 26/03/2023.
//

import Foundation
import SwiftUI

struct SlotIntent {

    @ObservedObject var slotVM : AssignedSlotViewModel
    
    
    init(slotVM : AssignedSlotViewModel) {
        self.slotVM = slotVM
    }
    
    func load(id: String) {
        slotVM.state = .loading
        Task {
            await self.loadAux(id: id)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedDataAux(result : APIResult<SlotDetailedDTO>){
        switch result {
        case .success(let slot):
            slotVM.state = .loadOne(slot)
        default:
            slotVM.state = .failed(.apiError)
        }
        
    }
    
    func loadAux(id: String) async {
        APITools.loadFromAPI(endpoint: "slots/full/" + id, callback: loadedDataAux, apiReturn: returnType.object.rawValue)
    }
}
