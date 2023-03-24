//
//  DaysListIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI

class DaysListIntent {
    
    @ObservedObject private var daysListVM : DaysListViewModel
    
    init(daysListVM: DaysListViewModel){
        self.daysListVM = daysListVM
    }
    
    func load(festivalID: String) {
        daysListVM.state = .loading
        Task {
            await self.loadAux(festivalID: festivalID)
        }
    }
    
    func delete(id: String) {
        daysListVM.state = .deleting
        Task {
            await self.deleteAux(id:id)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedData(result : APIResult<DayViewModel>){
        switch result{
        case .successList(let days):
            daysListVM.state = .load(days)
        default:
            daysListVM.state = .failed(.apiError)
        }
    }
    
    func loadAux(festivalID: String) async {
        APITools.loadFromAPI(endpoint: "days/festival/" + festivalID, callback: self.loadedData, apiReturn: returnType.array.rawValue)
    }
    
    func deleteAux(id: String) async {
        APITools.removeOnAPI(endpoint: "days", id: id)
        daysListVM.state = .idle
    }
}
