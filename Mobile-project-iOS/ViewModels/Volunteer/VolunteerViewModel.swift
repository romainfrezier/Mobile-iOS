//
//  VolunteerViewModel.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import Foundation

class VolunteerViewModel: ObservableObject, Decodable, Hashable, Equatable {
    
    static func == (lhs: VolunteerViewModel, rhs: VolunteerViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
      hasher.combine(self.id)
    }
    
    @Published var state: APIStates<VolunteerDTO> = .idle {
        didSet{
            switch state {
            case.loadOne(let volunteer):
                self.volunteer = volunteer
                self.state = .idle
            case .failed(let error):
                print("failed: \(error)")
            case .updateFestival(let festival):
                self.volunteer.festivalId = festival
                self.state = .idle
            default:
                print("VolunteerViewModel state : \(self.state)")
                break
            }
        }
    }
    
    var id: String
    @Published var volunteer: VolunteerDTO
    
    init() {
        self.id = ""
        self.volunteer = VolunteerDTO()
    }
    
    init(volunteerVM: VolunteerViewModel){
        self.volunteer = VolunteerDTO(id: volunteerVM.volunteer.id, firstName: volunteerVM.volunteer.firstName, lastName: volunteerVM.volunteer.lastName, emailAddress: volunteerVM.volunteer.emailAddress, firebaseId: volunteerVM.volunteer.firebaseId, festivalId: volunteerVM.volunteer.festivalId, isAdmin: volunteerVM.volunteer.isAdmin, availableSlots: volunteerVM.volunteer.availableSlots)
        self.id = volunteerVM.volunteer.id
    }
    
    init(id: String, firstName: String, lastName: String, emailAddress: String, firebaseId: String, festivalId: String?, isAdmin: Bool, availableSlots: Array<AvailableSlotsDTO>) {
        self.id = id
        self.volunteer = VolunteerDTO(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, firebaseId: firebaseId, festivalId: festivalId, isAdmin: isAdmin, availableSlots: availableSlots)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: VolunteerDTO.CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        let firstname = try values.decode(String.self, forKey: .firstName)
        let lastname = try values.decode(String.self, forKey: .lastName)
        let email = try values.decode(String.self, forKey: .emailAddress)
        let firebaseId = try values.decode(String.self, forKey: .firebaseId)
        let festivalId = try values.decode(String?.self, forKey: .festivalId)
        let isAdmin = try values.decode(Bool.self, forKey: .isAdmin)
        let availableSlots = try values.decode(Array<AvailableSlotsDTO>.self, forKey: .availableSlots)
        self.volunteer = VolunteerDTO(id: id, firstName: firstname, lastName: lastname, emailAddress: email, firebaseId: firebaseId, festivalId: festivalId, isAdmin: isAdmin, availableSlots: availableSlots)
    }
    
    func updateSlots(slots: [AvailableSlotsDTO]){
        self.volunteer.availableSlots = slots
    }
    
    func updtateFestival(festivalID: String){
        self.volunteer.festivalId = festivalID
    }
}
