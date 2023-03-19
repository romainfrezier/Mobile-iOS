//
//  LoggedInView.swift
//  AWI-IOS
//
//  Created by Romain on 07/03/2023.
//

import SwiftUI
import Firebase

struct LoggedInView: View {
    
    @Binding var isLoggedIn : Bool
    
    @State private var intent : AuthIntent
    @ObservedObject private var currentUser : AuthViewModel
    
    init(isLoggedIn : Binding<Bool>){
        self.currentUser = AuthViewModel()
        self.intent = AuthIntent(authVM: _currentUser.wrappedValue)
        self._isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        ZStack {
            switch currentUser.state {
            case .loading :
                ProgressView()
            case .idle :
                if currentUser.volunteer.isAdmin {
                    AdminHomeView(isLoggedIn: $isLoggedIn).environmentObject(currentUser)
                } else {
                    VolunteerHomeView(isLoggedIn: $isLoggedIn).environmentObject(currentUser)
                }
            default :
                CustomEmptyView()
            }
        }.onAppear{
            self.intent.load(uid: Auth.auth().currentUser!.uid)
        }
    }
}
