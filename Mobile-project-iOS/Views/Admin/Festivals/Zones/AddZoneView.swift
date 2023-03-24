//
//  AddZoneView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI
import AlertToast

struct AddZoneView: View {
    @State var zoneName : String = ""
    @State var volunteerNumber : Int = 1
    
    @State var intent : ZoneIntent = ZoneIntent(zoneVM: ZoneViewModel())
    @State var festivalID : String
    
    @Binding var isPresentedNewZone : Bool
    
    @Binding var toastMessage : String
    @State var showToast : Bool = false
    @Binding var showSuccessToast : Bool
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedNewZone.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (zoneName != ""){
                        intent.create(festivalID: self.festivalID, name: zoneName, volunteerNumber: self.volunteerNumber)
                        self.showSuccessToast.toggle()
                        self.toastMessage = "La zone a été ajoutée avec succès !"
                        self.isPresentedNewZone.toggle()
                    } else {
                        toastMessage = "Merci de donner un nom à la zone."
                        showToast.toggle()
                    }
                }
            }.padding()
            HStack {
                Text("Ajouter une zone").font(.title).bold()
                Spacer()
            }.padding()
            Spacer().frame(height: 100)
            ZStack(alignment: .bottom) {
                HStack {
                    TextField("Nom de la zone", text: $zoneName)
                        .background(Color.clear)
                        .padding()
                    Image(systemName: zoneName.count != 0 ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(zoneName.count != 0 ? .green : .red)
                }

                Rectangle()
                    .fill(zoneName == "" ? Color.red : Color.blue)
                    .frame(height: 1)
            }.padding()
            Stepper("Nombre de bénévoles : \(volunteerNumber)", value: $volunteerNumber, in: 1...Int.max).padding()
            Spacer()
            
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastMessage, subTitle: nil, style: nil)
            }
        }
    }
}
