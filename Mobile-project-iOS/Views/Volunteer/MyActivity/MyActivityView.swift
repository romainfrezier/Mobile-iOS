//
//  MyActivityView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 25/03/2023.
//

import SwiftUI

struct MyActivityView: View {
    
    var filters : [String] = ["Mes disponibilités", "Mes affectations"]
    @State private var selectedDisplay : String = "Mes disponibilités"
    
    @EnvironmentObject var currentUser : VolunteerViewModel
    
    @State var volunteerCurrentAvailibilities : [String] = []
    
    var body: some View {
        NavigationStack {
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
                    MyAvailabilitiesListView(vIntent: VolunteerIntent(volunteerVM: currentUser)).environmentObject(currentUser)
                case filters[1]:
                    MyAssignmentsListView(volunteerID: self.currentUser.volunteer.id)
                default:
                    CustomEmptyView()
                }
                
                Spacer()
            }
        }
    }
}

struct MyActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MyActivityView()
    }
}
