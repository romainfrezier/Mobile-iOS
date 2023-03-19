//
//  AuthView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 07/03/2023.
//

import SwiftUI

struct AuthView: View {
    
    @State private var currentViewShowing: String = "login"
    @State var userEmail : String = ""
    
    var body: some View {
        if(currentViewShowing == "login") {
            LoginView(emailToCheck: $userEmail, currentShowingView: $currentViewShowing)
        } else if (currentViewShowing == "reset"){
            ResetPasswordView(currentShowingView: $currentViewShowing).transition(.move(edge: .trailing))
        } else if (currentViewShowing == "check"){
            EmailCheckView(email: $userEmail, currentShowingView: $currentViewShowing).transition(.move(edge: .trailing))
        } else {
            SignupView(emailToCheck: $userEmail, currentShowingView: $currentViewShowing)
                .transition(.move(edge: .bottom))
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
