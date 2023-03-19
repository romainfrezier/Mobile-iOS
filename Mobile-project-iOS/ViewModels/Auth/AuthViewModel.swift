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
            case .load(let result):
                if (result.count == 1){
                    self.volunteer = result[0]
                    self.state = .idle
                } else {
                    self.state = .failed(.apiError)
                }
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
