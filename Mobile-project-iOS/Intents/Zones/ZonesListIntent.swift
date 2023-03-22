//
//  ZonesListIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation
import SwiftUI

struct ZonesListIntent {
    
    @ObservedObject private var zoneListVM : ZonesListViewModel
    
    init(zoneListVM : ZonesListViewModel){
        self.zoneListVM = zoneListVM
    }

    func loadByFestival(festival: String) {
        zoneListVM.state = .loading
        Task {
            await self.loadByFestivalAux(festival: festival)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedDataAux(result : APIResult<ZoneViewModel>){
        switch result {
        case .successList(let volunteers):
            zoneListVM.state = .load(volunteers)
        default:
            zoneListVM.state = .failed(.apiError)
        }
        
    }
    
    func loadByFestivalAux(festival: String) async {
        APITools.loadFromAPI(endpoint: "zones/festival/" + festival, callback: self.loadedDataAux, apiReturn: returnType.array.rawValue)
    }

}
