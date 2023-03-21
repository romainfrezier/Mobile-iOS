//
//  SignupView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 07/03/2023.
//

import SwiftUI
import Firebase
import GoogleSignIn
import AlertToast

struct SignupView: View {
    
    @Binding var emailToCheck : String
    @Binding var currentShowingView: String
    
    @State var intent : AuthIntent
    
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
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
                    Text("Créer un compte").font(.title).bold()
                    Spacer()
                }.padding().padding(.top)
                
                Spacer()
                
                Image("Logo").resizable().frame(width: 100, height: 100)
                
                Spacer()
                
                Group {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        TextField("Prénom", text: $firstName)
                        Spacer()
                        if(email.count != 0) {
                            
                            Image(systemName: firstName.count > 1 ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(firstName.count > 1 ? .green : .red)
                        }
                        
                    }.padding()
                    
                    HStack {
                        Image(systemName: "info.circle.fill")
                        TextField("Nom", text: $lastName)
                        Spacer()
                        if(email.count != 0) {
                            
                            Image(systemName: lastName.count > 1 ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(lastName.count > 1 ? .green : .red)
                        }
                        
                    }.padding()
                    
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
                    
                    HStack {
                        Image(systemName: "lock")
                        if isPasswordVisible {
                            TextField("Confirmer le mot de passe", text: $confirmPassword)
                        } else {
                            SecureField("Confirmer le mot de passe", text: $confirmPassword)
                        }
                        Spacer()
                        if(confirmPassword.count != 0) {
                            Image(systemName: StringTools.isValidPassword(password: password) && confirmPassword == password ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(StringTools.isValidPassword(password: password) && confirmPassword == password ? .green : .red)
                        }
                    }.padding()
                    
                    PasswordToggle(isPasswordVisible: $isPasswordVisible)
                    
                    Spacer()
                    
                    CustomButton(text: "S'inscrire", action: signupWithEmail)
                    
                    Text("ou").padding()
                    
                    GoogleButton(action: signupWithGoogle)
                }
                
                Spacer()
                
                Button("Se connecter"){
                    withAnimation{
                        self.currentShowingView = "login"
                    }
                }.padding(.vertical)
                
                Spacer()
            }
            .toast(isPresenting: $showErrorToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: errorMessage, subTitle: nil, style: nil)
            }
        }
    }
    
    func signupWithGoogle() -> Void {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  let emailGoogle = user.profile?.email,
                  let firstNameGoogle = user.profile?.givenName,
                  let lastNameGoogle = user.profile?.familyName
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
                
                self.intent.create(firebaseId: result!.user.uid, firstName: firstNameGoogle, lastName: lastNameGoogle, email: emailGoogle)
                
                withAnimation {
                    loggedIn = true
                }
            }
        }
    }
    
    func signupWithEmail() -> Void {
        if(StringTools.isValidPassword(password: password) && confirmPassword == password && StringTools.isValidEmail(email: email)) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    if (error.localizedDescription.contains("The email address is already in use by another account.")) {
                        errorMessage = "Un compte est déjà associé à cet e-mail."
                    } else {
                        errorMessage = "Une erreur est survenue"
                    }
                    print(error)
                    showErrorToast.toggle()
                    return
                }
                
                if self.authUser != nil && !self.authUser!.isEmailVerified {
                    self.intent.create(firebaseId: authUser!.uid, firstName: firstName, lastName: lastName, email: email)
                    self.authUser!.sendEmailVerification(completion: { (error) in
                        self.emailToCheck = self.authUser!.email!
                        self.currentShowingView = "check"
                    })
                } else {
                    return
                }
            }
        } else {
            errorMessage = "Veuillez remplir tous les champs"
            showErrorToast.toggle()
        }
    }
}
