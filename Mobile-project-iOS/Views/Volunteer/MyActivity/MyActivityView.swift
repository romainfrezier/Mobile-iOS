//
//  MyActivityView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 25/03/2023.
//

import SwiftUI

struct MyActivityView: View {
    
    var filters : [String] = ["Mes affectations", "Mes disponibilités"]
    @State private var selectedDisplay : String = "Mes affectations"
    
    @EnvironmentObject var currentUser : VolunteerViewModel
    
    @State var volunteerCurrentAvailibilities : [String] = []
    
    var body: some View {
        VStack {
            
            HStack{
                Text("Mon Activité").font(.title).bold()
                Spacer()
            }.padding()
            
            Picker(selection: $selectedDisplay, label: Text("Choisir un filtre")) {
                ForEach(filters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(SegmentedPickerStyle()).padding(.all)
            
            switch selectedDisplay {
            case filters[0]:
                MyAssignmentsListView(volunteerID: self.currentUser.volunteer.id)
            case filters[1]:
                MyAvailabilitiesListView(vIntent: VolunteerIntent(volunteerVM: currentUser)).environmentObject(currentUser)
            default:
                CustomEmptyView()
            }
            
            Spacer()
        }
    }
}

struct MyActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MyActivityView()
    }
}
