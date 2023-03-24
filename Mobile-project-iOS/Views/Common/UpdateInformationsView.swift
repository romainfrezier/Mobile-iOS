//
//  UpdateInformationsView.swift
//  Mobile-project-iOS
//
//  Created by etud on 24/03/2023.
//

import SwiftUI
import AlertToast

struct UpdateInformationsView: View {
    
    @State var intent : VolunteerIntent
    @ObservedObject var vm : VolunteerViewModel
    
    @EnvironmentObject var currentUser : AuthViewModel
    
    @Binding var isPresentedUpdate : Bool
    @Binding var displayName : String
    
    @Binding var toastMessage : String
    @State var showToast : Bool = false
    @Binding var showSuccessToast : Bool
    
    init(vm: VolunteerViewModel, isPresentedUpdate: Binding<Bool>, toastMessage: Binding<String>, showSuccessToast: Binding<Bool>,displayName: Binding<String>) {
        self.vm = vm
        self._intent = State(initialValue: VolunteerIntent(volunteerVM: self._vm.wrappedValue))
        self._isPresentedUpdate = isPresentedUpdate
        self._toastMessage = toastMessage
        self._showSuccessToast = showSuccessToast
        self._displayName = displayName
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedUpdate.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (vm.volunteer.firstName != "" && vm.volunteer.lastName != ""){
                        intent.update(id: vm.id, firstName: vm.volunteer.firstName, lastName: vm.volunteer.lastName)
                        self.showSuccessToast.toggle()
                        self.toastMessage = "Les informations ont été modifiées avec succès !"
                        self.currentUser.volunteer.firstName = vm.volunteer.firstName
                        self.currentUser.volunteer.lastName = vm.volunteer.lastName
                        self.displayName = vm.volunteer.firstName + " " + vm.volunteer.lastName
                        self.isPresentedUpdate.toggle()
                    } else if (vm.volunteer.firstName == "" ){
                        toastMessage = "Vous devez avoir un prénom"
                        showToast.toggle()
                    }
                    else if (vm.volunteer.lastName == "" ){
                        toastMessage = "Vous devez avoir un nom"
                        showToast.toggle()
                    }
                }
            }.padding()
            Spacer()
            ZStack(alignment: .bottom) {
                HStack {
                    TextField(vm.volunteer.firstName, text: $vm.volunteer.firstName)
                        .background(Color.clear)
                        .padding()
                    Image(systemName: vm.volunteer.firstName.count != 0 ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(vm.volunteer.firstName.count != 0 ? .green : .red)
                }

                Rectangle()
                    .fill(vm.volunteer.firstName == "" ? Color.red : Color.blue)
                    .frame(height: 1)
            }.padding()
            ZStack(alignment: .bottom) {
                HStack {
                    TextField(vm.volunteer.lastName, text: $vm.volunteer.lastName)
                        .background(Color.clear)
                        .padding()
                    Image(systemName: vm.volunteer.lastName.count != 0 ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(vm.volunteer.lastName.count != 0 ? .green : .red)
                }

                Rectangle()
                    .fill(vm.volunteer.lastName == "" ? Color.red : Color.blue)
                    .frame(height: 1)
            }.padding()
            Spacer()
            
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastMessage, subTitle: nil, style: nil)
            }
        }
    }
}

