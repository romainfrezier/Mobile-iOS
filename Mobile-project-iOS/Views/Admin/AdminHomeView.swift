//
//  AdminHomeView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 19/03/2023.
//

import SwiftUI

struct AdminHomeView: View {
    @EnvironmentObject var currentUser : VolunteerViewModel
    @Binding var isLoggedIn : Bool
    var body: some View {
        TabView {
            VolunteersListView().tabItem {
                Label("Bénévoles", systemImage: "person.2.fill")
            }.environmentObject(currentUser)
            
            FestivalsListView().tabItem{
                Label("Festivals", systemImage: "party.popper.fill")
            }
            
            ProfileView(isLoggedIn: $isLoggedIn).tabItem{
                Label("Profil", systemImage: "person.crop.circle.fill")
            }.environmentObject(currentUser)
        }
    }
}
