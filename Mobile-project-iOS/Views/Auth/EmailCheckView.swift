//
//  EmailCheckView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 08/03/2023.
//

import SwiftUI

struct EmailCheckView: View {
    
    @Binding var email : String
    @Binding var currentShowingView: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("Nous avons envoyé un email de vérification à \(email)")
                .multilineTextAlignment(.center)
                .padding(.bottom)
            Text("Merci de vérifier vos emails et de cliquer sur le lien de vérification pour activer votre compte.")
                .multilineTextAlignment(.center)
            Spacer()
            Button("Retour"){
                self.currentShowingView = "login"
            }
        }
        
    }
}
