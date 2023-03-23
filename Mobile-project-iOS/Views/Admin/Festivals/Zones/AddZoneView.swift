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
    
    @State var toastMessage : String = ""
    @State var showToast : Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedNewZone.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (zoneName != ""){
                        print(self.volunteerNumber)
                        intent.create(festivalID: self.festivalID, name: zoneName, volunteerNumber: self.volunteerNumber)
                        self.isPresentedNewZone.toggle()
                    } else {
                        toastMessage = "Merci de donner un nom à la zone."
                        showToast.toggle()
                    }
                }
            }.padding()
            Spacer()
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
