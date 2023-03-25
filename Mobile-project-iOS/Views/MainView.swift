//
//  ContentView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 19/03/2023.
//

import SwiftUI

struct MainView: View {
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @State private var intent : VolunteerIntent
    @ObservedObject var currentUser : VolunteerViewModel
    
    init(){
        self.currentUser = VolunteerViewModel()
        self.intent = VolunteerIntent(volunteerVM: self._currentUser.wrappedValue)
    }
    
    var body: some View {
        VStack {
            if !loggedIn {
                AuthView(intent: intent)
            } else {
                LoggedInView(isLoggedIn: $loggedIn, intent: intent).environmentObject(currentUser)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
