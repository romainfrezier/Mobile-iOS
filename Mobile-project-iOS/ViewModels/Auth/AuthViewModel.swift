//
//  AuthViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 08/03/2023.
//

import Foundation

class AuthViewModel: ObservableObject {
    
    @Published var state: APIStates<VolunteerDTO> = .idle {
        didSet{
            switch state {
            case .loadOne(let result):
                self.volunteer = result
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            default:
                print("AuthViewModel state : \(self.state)")
                break
            }
        }
    }
    
    @Published var volunteer: VolunteerDTO
    
    init() {
        self.volunteer = VolunteerDTO()
    }
}
