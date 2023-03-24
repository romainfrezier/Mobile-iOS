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
    @State var successMessage : String = ""
    @State var showSuccessToast : Bool = false
    
    @State private var isPresentedUpdate : Bool = false
    
    @State var userEmail : String = ""
    @State var displayName : String = ""
    
    @State private var showConfirmationDialog = false
    @State private var defaultImagePresented = false
    
    @EnvironmentObject var currentUser : AuthViewModel
    
    @State var hour : Int = 0

    
    var body: some View {
        VStack {
            AsyncImage(url: Auth.auth().currentUser!.photoURL){ phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else if let _ = phase.error {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable(resizingMode: .stretch)
                } else if (Auth.auth().currentUser!.photoURL == nil) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable(resizingMode: .stretch)
                }else {
                    ProgressView()
                }
                
            }
            .clipShape(Circle()).frame(width: 75, height: 75).overlay(Circle().stroke(.gray, lineWidth: 1).shadow(color: .gray, radius: 4, x: 0, y: 2)).padding()
            
            VStack {
                
                if currentUser.volunteer.isAdmin {
                    Text(displayName).font(.title).fontWeight(.bold).multilineTextAlignment(.center)
                    Text("(admin)").font(.caption).italic().padding(.bottom)
                } else {
                    Text(displayName).font(.title).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom)
                }
                
                switch currentUser.state {
                case .loading :
                    ProgressView()
                case .idle :
                    if hour >= 6 && hour < 18 {
                        Text("Bonjour ! ☀️").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding()
                    } else if hour >= 18 && hour < 22 {
                        Text("Bonsoir ! 🌙").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding()
                    } else {
                        Text("Bonne nuit ! 😴").font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding()
                    }
                default:
                    CustomEmptyView()
                }
                
            }
            
            Spacer()
            CustomButton(text: "Modifier mes informations", action: toggleUpdate).padding() // TODO : Page modif nom + prenom
            CustomButton(text: "Réinitialiser mon mot de passe", action: toggleShowConfirmationDialog).padding()
            CustomButton(text: "Se déconnecter", action: toggleIsLoggedIn).padding()
            Spacer()
        }.sheet(isPresented: $isPresentedUpdate) {
            UpdateInformationsView(vm: VolunteerViewModel(authVM: currentUser), isPresentedUpdate: $isPresentedUpdate, toastMessage: $successMessage, showSuccessToast: $showSuccessToast, displayName: $displayName).environmentObject(currentUser)
        }
        .onAppear{
            displayName = currentUser.volunteer.firstName + " " + currentUser.volunteer.lastName
            let date : Date = Date()
            self.hour = Calendar.current.component(.hour, from: date)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                self.defaultImagePresented.toggle()
            }
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
    private func toggleUpdate() -> Void {
        self.isPresentedUpdate.toggle()
    }
}
