//
//  FestivalIntent.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import Foundation
import SwiftUI

struct FestivalIntent{
    
    @ObservedObject private var festivalsListVM : FestivalsListViewModel
    @ObservedObject private var festivalVM : FestivalViewModel
    
    init(festivalsListVM: FestivalsListViewModel){
        self.festivalsListVM = festivalsListVM
        self.festivalVM = FestivalViewModel()
    }
    
    init(festivalVM: FestivalViewModel, festivalsListVM : FestivalsListViewModel){
        self.festivalVM = festivalVM
        self.festivalsListVM = festivalsListVM
    }
    
    func load() {
        festivalsListVM.state = .loading
        Task {
            await self.loadAux()
        }
    }

    func create(festival: FestivalDTO) {
        festivalVM.state = .creating
        Task {
            await self.createAux(festival: festival)
        }
    }

    func update(festival: FestivalDTO) {
        festivalVM.state = .updating
        Task {
            await self.updateAux(festival: festival)
        }
    }

    func delete(id: String) {
        festivalVM.state = .deleting
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
        APITools.loadFromAPI(endpoint: "", callback: self.loadedData, apiReturn: returnType.array.rawValue)
    }
    
    func createAux(festival: FestivalDTO) async {
        let data : [String: Any] = festival.getBody()
        APITools.createOnAPI(endpoint: "", body: data)
        festivalVM.state = .idle
    }

    func updateAux(festival: FestivalDTO) async {
        let data : [String: Any] = festival.getBody()
        APITools.updateOnAPI(endpoint: "", id: festival.id, body: data)
        festivalVM.state = .idle
    }
    
    func deleteAux(id: String) async {
        APITools.removeOnAPI(endpoint: "", id: id)
        festivalVM.state = .idle
    }
    
    
}
