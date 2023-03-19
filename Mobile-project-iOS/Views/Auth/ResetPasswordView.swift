//
//  ResetPasswordView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 07/03/2023.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore

struct ResetPasswordView: View {
    
    @Binding var currentShowingView: String
    
    @State private var email: String = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Mot de passe oublié").font(.title).fontWeight(.bold).padding()
                    Spacer()
                }
                Spacer()
                
                Image("Logo").resizable().frame(width: 100, height: 100)
                
                Spacer()
                Text("Veuillez entrer votre adresse e-mail afin de réinitiliser votre mot de passe").font(.caption).multilineTextAlignment(.center).padding()
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email", text: $email)
                    Spacer()
                    if(email.count != 0) {
                        Image(systemName: StringTools.isValidEmail(email: email) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(StringTools.isValidEmail(email: email) ? .green : .red)
                    }
                }.padding()
                
                CustomButton(text: "Réinitialiser", action: toggleDialog).padding()
                
                Spacer()
                
                .confirmationDialog("Change background", isPresented: $showingConfirmation) {
                    Button("Réinitialiser", role: .destructive) { resetPassword() }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Select a new color")
                }

                Button("Annuler"){
                    withAnimation{
                        self.currentShowingView = "login"
                    }
                }.padding()
            }
        }
    }
    
    private func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error)
                return
            }
            withAnimation{
                self.currentShowingView = "login"
            }
        }
    }
    
    private func toggleDialog() -> Void {
        self.showingConfirmation.toggle()
    }
}
