//
//  FestivalAddView.swift
//  AWI-IOS
//
//  Created by Romain on 06/03/2023.
//

import SwiftUI
import AlertToast

struct FestivalAddView: View {
    
    @ObservedObject var vm : FestivalDetailedViewModel
    @State var intent : FestivalIntent
    
    @Binding var isPresented : Bool
    
    @Binding var toastMessage : String
    @Binding var showErrorToast : Bool
    @State private var showLocalErrorToast : Bool = false
    @Binding var showSuccessToast : Bool
    
    init(vm: FestivalViewModel, isPresented: Binding<Bool>, toastMessage: Binding<String>, showErrorToast: Binding<Bool>, showSuccessToast: Binding<Bool>) {
        self.vm = FestivalDetailedViewModel(festivalVM: vm)
        self._intent = State(initialValue: FestivalIntent(festivalVM: self._vm.wrappedValue))
        
        self._isPresented = isPresented
        
        self._toastMessage = toastMessage
        self._showErrorToast = showErrorToast
        self._showSuccessToast = showSuccessToast
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
//                Form {
//                    Section(header: Text("NOM")){
//                        TextField("Prénom", text: $firstName)
//                        TextField("Nom", text: $lastName)
//                    }
//
//                    Section(header: Text("Email")) {
//                        TextField("Email", text: $emailAddress).keyboardType(.emailAddress)
//                    }
//
//                    Section {
//                        addButton
//                    }
//                }
//                .toast(isPresenting: $showLocalErrorToast){
//                    AlertToast(displayMode: .banner(.slide), type: .error(.red), title: errorMessage, subTitle: nil, style: nil)
//                }
            }
            .navigationBarTitle("Ajouter un festival")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        toastMessage = "Le festival n'a pas été créé."
                        showErrorToast.toggle()
                        isPresented.toggle()
                    }
                }
            }
        }
    }
    
//    var addButton : some View {
//        VStack{
//            Button("Enregister") {
//                if (firstName != "" && lastName != "" && emailAddress != ""){
//                    let createdVolunteer = VolunteerDTO(id: "", firstName: firstName, lastName: lastName, emailAddress: emailAddress)
//                    intent.create(volunteer: createdVolunteer)
//                    successMessage = "Le bénévole a bien été créé."
//                    showSuccessToast.toggle()
//                    isPresented.toggle()
//                } else {
//                    errorMessage = "Tous les champs doivent être remplis."
//                    showLocalErrorToast.toggle()
//                }
//            }
//        }
//    }
}
