//
//  ProfileView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 07/03/2023.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    @Binding var isLoggedIn : Bool
    
    @State var userEmail : String = ""
    @State var displayName : String = ""
    
    @State private var showConfirmationDialog = false
    
    @State private var intent : AuthIntent
    @ObservedObject private var vm : AuthViewModel
    
    init(isLoggedIn : Binding<Bool>){
        self.vm = AuthViewModel()
        self.intent = AuthIntent(authVM: _vm.wrappedValue)
        self._isLoggedIn = isLoggedIn
    }
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    @State var hour : Int = 0
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable(resizingMode: .stretch)
                .frame(width: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/).padding()
            switch vm.state {
            case .loading :
                ProgressView()
            case .idle :
                if hour >= 6 && hour < 18 {
                    Text("Bonjour \(displayName) ☀️").font(.title).fontWeight(.bold).multilineTextAlignment(.center).padding()
                } else {
                    Text("Bonsoir \(displayName) 🌙").font(.title).fontWeight(.bold).multilineTextAlignment(.center).padding()
                }
            default:
                CustomEmptyView()
            }
            
            Spacer()
            CustomButton(text: "Réinitialiser mon mot de passe", action: toggleShowConfirmationDialog)
            CustomButton(text: "Se déconnecter", action: toggleIsLoggedIn).padding()
            Spacer()
        }
        .onAppear{
            if self.authUser != nil {
                intent.load(uid: authUser!.uid)
                displayName = vm.volunteer.firstName + " " + vm.volunteer.lastName
            }
            let date : Date = Date()
            self.hour = Calendar.current.component(.hour, from: date)
        }
        .alert(isPresented: $showConfirmationDialog) {
            Alert(
                title: Text("Réinitialiser le mot de passe"),
                message: Text("Êtes vous sûr de vouloir réinitialiser votre mot de passe ? Vous ne pourrez plus revenir en arrière."),
                primaryButton: .destructive(Text("Réinitialiser")) {
                    self.resetPassword()
                },
                secondaryButton: .cancel(Text("Annuler"))
            )
        }
    }
    
    private func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
            if let error = error {
                print(error)
                return
            }
            isLoggedIn.toggle()
        }
    }
    
    private func toggleIsLoggedIn() -> Void {
        self.isLoggedIn.toggle()
    }
    
    private func toggleShowConfirmationDialog() -> Void {
        self.showConfirmationDialog.toggle()
    }
}
