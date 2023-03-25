//
//  VolunteerHomeView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 19/03/2023.
//

import SwiftUI

struct VolunteerHomeView: View {
    @EnvironmentObject var currentUser : VolunteerViewModel
    @Binding var isLoggedIn : Bool
    var body: some View {
        if (currentUser.volunteer.festivalId == nil) {
            ChooseFestivalView().environmentObject(currentUser)
        } else {
            TabView {
                MyFestivalView().tabItem{
                    Label("Mon festival", systemImage: "party.popper.fill")
                }.environmentObject(currentUser)
                
                CustomEmptyView().tabItem{
                    Label("Mon activité", systemImage: "trophy.fill")
                }.environmentObject(currentUser)
                
                OtherFestivalsListView().tabItem{
                    Label("Autres festivals", systemImage: "balloon.2.fill")
                }.environmentObject(currentUser)
                
                ProfileView(isLoggedIn: $isLoggedIn).tabItem{
                    Label("Profil", systemImage: "person.fill")
                }.environmentObject(currentUser)
            }
        }
    }
}
