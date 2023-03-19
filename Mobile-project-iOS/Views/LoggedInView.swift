//
//  LoggedInView.swift
//  AWI-IOS
//
//  Created by Romain on 07/03/2023.
//

import SwiftUI

struct LoggedInView: View {
    
    @Binding var isLoggedIn : Bool
    
    var body: some View {
        TabView {
            CustomEmptyView().tabItem{
                Label("Festivals", systemImage: "party.popper.fill")
            }
            
            ProfileView(isLoggedIn: $isLoggedIn).tabItem{
                Label("Profil", systemImage: "person.fill")
            }
        }
    }
}
