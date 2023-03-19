//
//  LoginView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 07/03/2023.
//

import SwiftUI
import Firebase
import GoogleSignIn
import AlertToast

struct LoginView: View {
    
    @Binding var emailToCheck : String
    @Binding var currentShowingView: String
    
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var errorMessage : String = ""
    @State private var isPasswordVisible = false
    @State private var showErrorToast : Bool = false
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    var body: some View {
        ZStack {
            VStack {
                
                HStack {
                    Text("Se connecter").font(.title).bold()
                    Spacer()
                }.padding()
                
                Spacer()
                
                Image("Logo").resizable().frame(width: 100, height: 100)
                
                Spacer()
                
                Group{
                    HStack {
                        Image(systemName: "envelope")
                        TextField("Email", text: $email).keyboardType(.emailAddress)
                        Spacer()
                        if(email.count != 0) {
                            Image(systemName: StringTools.isValidEmail(email: email) ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(StringTools.isValidEmail(email: email) ? .green : .red)
                        }
                    }.padding()
                    
                    HStack {
                        Image(systemName: "lock")
                        if isPasswordVisible {
                            TextField("Mot de passe", text: $password)
                        } else {
                            SecureField("Mot de passe", text: $password)
                        }
                        Spacer()
                        if(password.count != 0) {
                            Image(systemName: StringTools.isValidPassword(password: password) ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(StringTools.isValidPassword(password: password) ? .green : .red)
                        }
                    }.padding()
                    
                    PasswordToggle(isPasswordVisible: $isPasswordVisible)
                    
                    Spacer()
                    
                    CustomButton(text: "Se connecter", action: loginWithEmail).padding([.top, .leading, .trailing])
                    
                    Text("ou")
                    
                    GoogleButton(action: loginWithGoogle)
                }
                
                Spacer()
                VStack(alignment: .center) {
                    Button("Créer un compte"){
                        withAnimation{
                            self.currentShowingView = "signup"
                        }
                    }
                    Spacer().frame(height: 10)
                    Button("Mot de passe oublié"){
                        withAnimation{
                            self.currentShowingView = "reset"
                        }
                    }.padding(.bottom)
                }.padding(.vertical)
                Spacer()
            }
            .toast(isPresenting: $showErrorToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: errorMessage, subTitle: nil, style: nil)
            }
        }
    }
    
    func loginWithGoogle() -> Void {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard result != nil else {
                    return
                }
                
                withAnimation {
                    loggedIn = true
                }
            }
        }
    }
    
    func loginWithEmail() -> Void {
        if(StringTools.isValidPassword(password: password) && StringTools.isValidEmail(email: email)) {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    errorMessage = "Une erreur est survenue"
                    print(error)
                    showErrorToast.toggle()
                    return
                }
                
                guard self.authUser != nil else {
                    return
                }
                
                if !self.authUser!.isEmailVerified {
                    self.emailToCheck = self.authUser!.email!
                    self.currentShowingView = "check"
                } else {
                    self.loggedIn = true
                }
            }
        } else {
            errorMessage = "Veuillez remplir tous les champs"
            showErrorToast.toggle()
        }
    }
}
