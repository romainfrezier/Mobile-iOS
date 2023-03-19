//
//  AuthIntent.swift
//  Mobile-project-iOS
//
//  Created by Romain on 19/03/2023.
//

import Foundation
import SwiftUI

struct AuthIntent {
    
    @ObservedObject private var authVM : AuthViewModel
    
    init(authVM: AuthViewModel){
        self.authVM = authVM
    }
    
    init() {
        self.authVM = AuthViewModel()
    }

    func load(uid: String) {
        authVM.state = .loading
        Task {
            await self.loadAux(uid: uid)
        }
    }
    
    // MARK: - Aux async function to call API
    func loadedData(result : APIResult<VolunteerDTO>){
        switch result {
        case .success(let value):
            authVM.state = .loadOne(value)
        default:
            authVM.state = .failed(.apiError)
        }
    }
    
    func loadAux(uid: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/firebase/" + uid, callback: self.loadedData)
    }
}

