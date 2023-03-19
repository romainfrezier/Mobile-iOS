//
//  ContentView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 19/03/2023.
//

import SwiftUI

struct MainView: View {
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @State var volunteer : VolunteerDTO = VolunteerDTO()
    
    var body: some View {
        VStack {
            if !loggedIn {
                AuthView()
            } else if volunteer.isAdmin {
                LoggedInView(isLoggedIn: $loggedIn)
            } else {
                LoggedInView(isLoggedIn: $loggedIn)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
