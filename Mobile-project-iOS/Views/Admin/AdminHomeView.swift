//
//  AdminHomeView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 19/03/2023.
//

import SwiftUI

struct AdminHomeView: View {
    @EnvironmentObject var currentUser : AuthViewModel
    @Binding var isLoggedIn : Bool
    var body: some View {
        TabView {
            CustomEmptyView().tabItem{
                Label("Festivals", systemImage: "party.popper.fill")
            }
            
            ProfileView(isLoggedIn: $isLoggedIn).tabItem{
                Label("Profil", systemImage: "person.fill")
            }.environmentObject(currentUser)
        }
    }
}
