//
//  VolunteerDetailView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import SwiftUI

struct VolunteerDetailView: View {
    
    @ObservedObject var vm : VolunteerViewModel;
    @Binding var intent : VolunteerIntent
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @Binding var successMessage : String
    @Binding var showSuccessToast : Bool
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(vm.volunteer.firstName).font(.title).bold()
                    Text(vm.volunteer.lastName).font(.title).bold()
                    Spacer()
                }.padding()
                
                Spacer()
                
                HStack {
                    Image(systemName: "info.circle.fill")
                    Text("Informations")
                    Spacer()
                }.padding([.leading, .trailing])
                VStack {
                    HStack {
                        Text("Email :").bold()
                        Text(vm.volunteer.emailAddress)
                        Spacer()
                    }.padding([.leading, .top])
                    HStack {
                        Text("Festival :").bold()
                        Text(vm.volunteer.festivalId ?? "Pas de festival")
                        Spacer()
                    }.padding([.leading, .top])
                    HStack {
                        Text(vm.volunteer.isAdmin ? "Ce bénévole est un admin." : "")
                        Spacer()
                    }.padding([.leading, .top, .bottom])
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                ).padding([.leading, .trailing])
                
                
                Spacer()
                
            }
        }
    }
}
