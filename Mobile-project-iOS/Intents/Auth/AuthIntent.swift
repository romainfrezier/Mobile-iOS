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

    func load(firebaseId: String) {
        authVM.state = .loading
        Task {
            await self.loadAux(firebaseId: firebaseId)
        }
    }
    
    func create(firebaseId : String, firstName : String, lastName : String, email : String){
        authVM.state = .creating
        Task {
            await self.createAux(firebaseId : firebaseId, firstName : firstName, lastName : lastName, email : email);
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
    
    func loadAux(firebaseId: String) async {
        APITools.loadFromAPI(endpoint: "volunteers/firebase/" + firebaseId, callback: self.loadedData, apiReturn: returnType.object.rawValue)
    }
    
    func createAux(firebaseId : String, firstName : String, lastName : String, email : String) async {
        let body : [String : Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "firebaseId": firebaseId
        ]
        APITools.createOnAPI(endpoint: "volunteers", body: body)
        self.authVM.state = .idle
    }
}

